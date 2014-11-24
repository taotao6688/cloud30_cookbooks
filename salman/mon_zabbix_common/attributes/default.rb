#!/usr/bin/ruby

default[:mon][:zabbix][:cloud30][:sol_id]="1234"
default[:mon][:zabbix][:cloud30][:sol_name]="test"

default[:mon][:zabbix][:cloud30][:vm_id]="4567"
default[:mon][:zabbix][:cloud30][:vm_ip]="1.2.3.4"
default[:mon][:zabbix][:cloud30][:vm_name]="vm"

default[:mon][:zabbix][:cloud30][:zabbix_server][:host]="1.2.3.5"
default[:mon][:zabbix][:cloud30][:zabbix_server][:user]="Admin"
default[:mon][:zabbix][:cloud30][:zabbix_server][:password]="zabbix"
default[:mon][:zabbix][:cloud30][:zabbix][:templates]=[ "Template OS Linux" ]

default[:mon][:zabbix][:cloud30][:zabbix][:workdir] = "/root/zabbix/workdir"
default[:mon][:zabbix][:cloud30][:zabbix][:agent_installer] = "zabbix-agent-2.2.5-1.el6.x86_64.rpm"
default[:mon][:zabbix][:cloud30][:zabbix][:sender_installer] = "zabbix-sender-2.2.5-1.el6.x86_64.rpm"
default[:mon][:zabbix][:cloud30][:zabbix][:zabbix_installer] = "zabbix-2.2.5-1.el6.x86_64.rpm"

default[:mon][:zabbix][:cloud30][:log_file] = "/tmp/monitoring.log"
