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
    if login_cfg != None and zabbix_url != None:
        username = login_cfg.split(',')[0]
        passwd = login_cfg.split(',')[1]
        zabbix_obj = zabbix_api.ZabbixAPI(server = zabbix_url)
        zabbix_obj.login(user = username, password = passwd)

    return zabbix_obj

# Associate a template with a host
def associate_template(zabbix_obj, host_name, template_name):
    rc = 0
    result = []
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

        hostid = host_entry[0]['hostid']

        # Get the new template and id
        new_template = zabbix_obj.template.get(
            {
                'filter' : { 'name' : template_name},
                'output' : 'extend'
            })
        if not new_template:
            rc = 3
            return rc,result

        new_template_id = dict()
        new_template_id['templateid'] = new_template[0]['templateid']

        # Get the current set of templateids associated with the host
        current_template_list = zabbix_obj.template.get(
            {
                'hostids' : hostid,
                'output' : 'extend'
            })
        current_template_id_list = []
        for entry in current_template_list:
            if entry['templateid'] != new_template_id['templateid']:
                temp_dict = dict()
                temp_dict['templateid'] = entry['templateid']
                current_template_id_list.append(temp_dict)

        # Update the host with this new template id
        current_template_id_list.append(new_template_id)

        result = zabbix_obj.host.update(
            {
                'hostid' : hostid,
                'templates' : current_template_id_list
            })

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
    p.add_option("-n", action="store", dest="name", help="VM name")
    p.add_option("-i", action="store", dest="id", help="VM UUID")
    p.add_option("-t", action="store", dest="template_name", help="Template name")

    opts, args = p.parse_args()
    if not opts.name or not opts.id or not opts.template_name:
        print 'Usage: python associate_template.py -n <vm_name> -i <vm_instance_id> -t <template_name>'
        exit(1)

    host_name = str(opts.name) + '-' + str(opts.id)
    template_name = str(opts.template_name)

    # Initialize/login zabbix object
    zabbix_obj = init()

    rc, result = associate_template(zabbix_obj, host_name, template_name)
    if rc == 0:
        print 'Associated template with host; ' + str(result)
    elif rc == 2:
        print 'Host not found' + str(result)
    elif rc == 3:
        print 'Template not found' + str(result)
    else:
        print 'Failed to associate template; ' + str(result)

if __name__=="__main__":
    main()

