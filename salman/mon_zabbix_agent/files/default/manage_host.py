import optparse
import pdb
import sys
import logging
import ConfigParser
import zabbix_api

log = logging.getLogger()
template_id_list = []

def init():
    zabbix_obj = None
    global template_id_list

    # Read from Zabbix credentials config file
    config = ConfigParser.RawConfigParser()
    config.read('login.cfg')
    zabbix_url = config.get('zabbix','url')
    login_cfg = config.get('zabbix', 'login')
    template_names = config.get('zabbix','templates')
    if login_cfg != None and zabbix_url != None:
        username = login_cfg.split(',')[0]
        passwd = login_cfg.split(',')[1]
        zabbix_obj = zabbix_api.ZabbixAPI(server = zabbix_url)
        zabbix_obj.login(user = username, password = passwd)

        # Get the templateids
        template_names_list = [entry.strip() for entry in template_names.split(',')]
        template_list = zabbix_obj.template.get(
            {
                'filter' : { 'host' : template_names_list },
                'output':'extend'
            })

        template_id_list = [entry['templateid'] for entry in template_list]
        #print template_id_list 

    return zabbix_obj

# Create a Zabbix host
def create_host(zabbix_obj, host_name, host_ip, hostgroup_name):
    rc = 0
    result = []
    global template_id_list
    try:
        # Check if host already exists
        host_entry = zabbix_obj.host.get(
            { 
                'filter' : { 'host' : host_name },
                'output' : 'extend'
            })
        if host_entry:
            # Delete and recreate the host
            del_rc, del_result = delete_host(zabbix_obj, host_name)

        # Get the hostgroup entry
        hostgroup_entry = zabbix_obj.hostgroup.get(
            { 
                'filter' : { 'name' : hostgroup_name },
                'output' : 'extend'
            })
        if hostgroup_entry:
            host_dict = { 
                    'host' : host_name,
                    'interfaces' : [
                        {
                            'type' : 1,
                            'main' : 1,
                            'useip' : 1,
                            'ip' : host_ip,
                            'dns' : '',
                            'port' : '10050'
                        }],
                    'groups' : [
                        {
                            'groupid' : hostgroup_entry[0]['groupid']
                        }]
                }
            if template_id_list:
                host_dict['templates'] = []
                for template_entry in template_id_list:
                    template_entry_str = template_entry.strip()
                    template_dict = dict()
                    template_dict['templateid'] = template_entry_str
                    host_dict['templates'].append(template_dict)

            # Create the host
            result = zabbix_obj.host.create(host_dict)
            print result
        else:
            rc = 2
            result = []
    except Exception as e:
        logging.error("Exception: %s"%(sys.exc_info()[1]))
        rc = 1
        pass

    return rc, result

# Delete a zabbix host
def delete_host(zabbix_obj, host_name):
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
        if host_entry:
            # Get the ID of the host 
            host_id_array = []
            host_id_array.append(host_entry[0]['hostid'])
            result = zabbix_obj.host.delete(host_id_array)
        else:
            rc = 2
            result = []
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
    p.add_option("-c", action="store", dest="command", help="Command [CREATE/DELETE] VM entry")
    p.add_option("-n", action="store", dest="name", help="VM name")
    p.add_option("-i", action="store", dest="id", help="VM UUID")
    p.add_option("-p", action="store", dest="ip", help="VM IP")
    p.add_option("-s", action="store", dest="sol_name", help="Solution name")
    p.add_option("-d", action="store", dest="sol_id", help="Solution instance ID")

    opts, args = p.parse_args()
    if not opts.command or not opts.name or not opts.id or not opts.ip or not opts.sol_name or not opts.sol_id:
        print 'Usage: python manage_host.py -c <command> -n <vm_name> -i <vm_instance_id> -p <vm_ip> -s <solution_name> -d <solution_instance_id>'
        exit(1)

    command = opts.command
    host_name = str(opts.name) + '-' + str(opts.id)
    host_ip = opts.ip
    hostgroup_name = str(opts.sol_name) + '-' + str(opts.sol_id)

    # Initialize/login zabbix object
    zabbix_obj = init()

    if command.lower() == 'create':
        rc, result = create_host(zabbix_obj, host_name, host_ip, hostgroup_name)
        if rc == 0:
            print 'Created host; ' + str(result)
        elif rc == 2:
            print 'No hostgroup with name ' + hostgroup_name
        else:
            print 'Failed to create host; ' + str(result)
    elif command.lower() == 'delete':
        rc, result = delete_host(zabbix_obj, host_name)
        if rc == 0:
            print 'Deleted host; ' + str(result)
        elif rc == 2:
            print 'No host with name ' + host_name
        else:
            print 'Failed to delete host; ' + str(result)
    else: 
        print 'Command should either be "create" or "delete"'

if __name__=="__main__":
    main()

