import optparse
import pdb
import sys
import logging
import ConfigParser
import zabbix_api

log = logging.getLogger()

def init():
    zabbix_obj = None
    global template_id_list

    # Read from Zabbix credentials config file
    config = ConfigParser.RawConfigParser()
    config.read('login.cfg')
    zabbix_url = config.get('zabbix','url')
    login_cfg = config.get('zabbix', 'login')
    if login_cfg != None and zabbix_url != None:
        username = login_cfg.split(',')[0]
        passwd = login_cfg.split(',')[1]
        zabbix_obj = zabbix_api.ZabbixAPI(server = zabbix_url)
        zabbix_obj.login(user = username, password = passwd)

    return zabbix_obj

# Create an application and associate a set of metrics with it
def create_application(zabbix_obj, host_name, entity_id, metric_key_prefix):
    rc = 0
    result = []
    try:
        # Check if host exists
        host_entry = zabbix_obj.host.get(
            { 
                'filter' : { 'host' : host_name },
                'output' : 'extend'
            })
        if not host_entry:
            rc = 2
            return rc, result

        # Check if application exists
        app_entry_list = zabbix_obj.application.get(
            {
                'hostids' : host_entry[0]['hostid'],
                'filter' : { 'name' : entity_id },
                'output' : 'extend'
            })

        if app_entry_list:
            # An application with this entity_id already exists
            rc = 3
            return rc,result

        # Create the application
        result = zabbix_obj.application.create(
            {
                'name' : entity_id,
                'hostid' : host_entry[0]['hostid']
            })
        if result:
            new_app_id = result['applicationids'][0]
            
            # Associate the right metrics with this application
            item_entries = zabbix_obj.item.get(
                {
                    'hostids' : host_entry[0]['hostid'],
                    'output' : 'extend',
                })

            # Create the input dictionary
            input_dict = dict()
            app_dict_list = []
            app_dict = { 'applicationid' : new_app_id }
            app_dict_list.append(app_dict)
            input_dict['applications'] = app_dict_list
            
            item_list = []
            for item_entry in item_entries:
                if item_entry['key_'].startswith(metric_key_prefix):
                    # This metric is to be included
                    item_dict = { 'itemid' : item_entry['itemid'] }
                    item_list.append(item_dict)

            input_dict['items'] = item_list
                
            # Update the association of items to the new application
            res = zabbix_obj.application.massadd(input_dict)

        else:
            rc = 1

    except Exception as e:
        logging.error("Exception: %s"%(sys.exc_info()[1]))
        rc = 1
        pass

    return rc, result

# Delete an application
def delete_application(zabbix_obj, host_name, entity_id):
    rc = 0
    result = []
    #pdb.set_trace()
    try:
        # Get the host entry
        host_entry = zabbix_obj.host.get(
            { 
                'filter' : { 'host' : host_name },
                'output' : 'extend'
            })
        if not host_entry:
            rc = 2
            return rc, result

        # Get the application corresponding to this entity
        app_entry_list = zabbix_obj.application.get(
            {
                'hostids' : host_entry[0]['hostid'],
                'filter' : { 'name' : entity_id },
                'output' : 'extend'
            })

        app_id_list = [entry['applicationid'] for entry in app_entry_list]

        # Delete the applications 
        result = zabbix_obj.application.delete(app_id_list)
        print result

    except Exception as e:
        logging.error("Exception: %s"%(sys.exc_info()[1]))
        rc = 1
        pass

    return rc, result


def main():
    log.setLevel('DEBUG')
    handler = logging.StreamHandler()
    handler.setFormatter(logging.Formatter("%(asctime)s [%(levelname)s] %(name)s: %(message)s"))
    log.addHandler(handler)

    p = optparse.OptionParser()
    p.add_option("-c", action="store", dest="command", help="Command [CREATE/DELETE] Entity")
    p.add_option("-n", action="store", dest="vm_name", help="VM name")
    p.add_option("-i", action="store", dest="vm_id", help="VM UUID")
    p.add_option("-e", action="store", dest="entity_id", help="Entity ID")
    p.add_option("-m", action="store", dest="key_prefix", help="Metric key prefix")

    opts, args = p.parse_args()
    if not opts.command or  not opts.vm_name or not opts.vm_id:
        print 'Usage: python manage_application.py -c <command> -n <vm_name> -i <vm_uuid> -e <entity_id> -m <metric_key_prefix>'
        exit(1)

    if opts.command.lower() == 'create' and not opts.entity_id:
        print 'Usage: python manage_application.py -c CREATE -n <vm_name> -i <vm_uuid> -e <entity_id> -m <metric_key_prefix>'
        exit(1)

    command = opts.command
    host_name = str(opts.vm_name) + '-' + str(opts.vm_id)
    if opts.entity_id:
        entity_id = 'mon-' + opts.entity_id
    else:
        entity_id = ''
    if opts.key_prefix:
        key_prefix = opts.key_prefix
    else:
        key_prefix = ''

    # Initialize/login zabbix object
    zabbix_obj = init()

    if command.lower() == 'create':
        rc, result = create_application(zabbix_obj, host_name, entity_id, key_prefix)
        if rc == 0:
            print 'Created application; ' + str(result)
        elif rc == 2:
            print 'No host with name ' + host_name
        elif rc == 3:
            print 'Application with entity_id ' + entity_id + ' already exists. Failed.'
        else:
            print 'Failed to create application; ' + str(result)
    elif command.lower() == 'delete':
        rc, result = delete_application(zabbix_obj, host_name, entity_id)
        if rc == 0:
            print 'Deleted application; ' + str(result)
        elif rc == 2:
            print 'No host with name ' + host_name
        else:
            print 'Failed to delete application; ' + str(result)
    else: 
        print 'Command should either be "create" or "delete"'

if __name__=="__main__":
    main()

