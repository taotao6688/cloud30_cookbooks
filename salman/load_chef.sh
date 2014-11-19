knife cookbook upload mon_zabbix_agent -o .
knife cookbook upload mon_zabbix_common -o .
knife cookbook upload mon_zabbix_db2 -o .
knife cookbook upload mon_zabbix_hadoop -o .

knife role from file roles/mon_zabbix_hadoop.json
knife role from file roles/mon_zabbix_db2.json
knife role from file roles/mon_zabbix_agent.json

knife environment from file mon-sal-bi.json
