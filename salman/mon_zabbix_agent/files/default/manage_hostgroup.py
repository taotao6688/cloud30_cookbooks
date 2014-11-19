import optparse
import pdb
import sys
import logging
import ConfigParser
import zabbix_api

log = logging.getLogger()

def init():
    zabbix_obj = None

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

# Create a Zabbix hostgroup
def create_hostgroup(zabbix_obj, hostgroup_name):
    rc = 0
    result = []
    try:
        # Check if hostgroup already exists
        hostgroup_entry = zabbix_obj.hostgroup.get(
            { 
                'filter' : { 'name' : hostgroup_name },
                'output' : 'extend'
            })
        if not hostgroup_entry:
            result = zabbix_obj.hostgroup.create({ 'name' : hostgroup_name })
        else:
            rc = 2
        #print result
    except Exception as e:
        logging.error("Exception: %s"%(sys.exc_info()[1]))
        rc = 1
        pass

    return rc, result

# Delete a zabbix hostgroup
def delete_hostgroup(zabbix_obj, hostgroup_name):
    rc = 0
    result = []
    try:
        # Get the hostgroup entry
        hostgroup_entry = zabbix_obj.hostgroup.get(
            { 
                'filter' : { 'name' : hostgroup_name },
                'output' : 'extend'
            })
        if hostgroup_entry:
            # Get the ID of the hostgroup    
            hostgroup_id_array = []
            hostgroup_id_array.append(hostgroup_entry[0]['groupid'])
            result = zabbix_obj.hostgroup.delete(hostgroup_id_array)
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
    p.add_option("-c", action="store", dest="command", help="Command [CREATE/DELETE] solution instance")
    p.add_option("-s", action="store", dest="name", help="Solution name")
    p.add_option("-d", action="store", dest="id", help="Solution instance ID")

    opts, args = p.parse_args()
    if not opts.command or not opts.name or not opts.id:
        print 'Usage: python manage_hostgroup.py -c <command> -s <solution_name> -d <solution_instance_id>'
        exit(1)

    command = opts.command
    hostgroup_name = str(opts.name) + '-' + str(opts.id)

    # Initialize/login zabbix object
    zabbix_obj = init()

    if command.lower() == 'create':
        rc, result = create_hostgroup(zabbix_obj, hostgroup_name)
        if rc == 0:
            print 'Created hostgroup; ' + str(result)
        elif rc == 2:
            print 'Hostgroup already exists'
        else:
            print 'Failed to create hostgroup; ' + str(result)
    elif command.lower() == 'delete':
        rc, result = delete_hostgroup(zabbix_obj, hostgroup_name)
        if rc == 0:
            print 'Deleted hostgroup; ' + str(result)
        elif rc == 2:
            print 'No hostgroup with name ' + hostgroup_name
        else:
            print 'Failed to delete hostgroup; ' + str(result)
    else: 
        print 'Command should either be "create" or "delete"'

if __name__=="__main__":
    main()

