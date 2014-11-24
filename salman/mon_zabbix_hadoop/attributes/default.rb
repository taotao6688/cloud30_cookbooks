#!/usr/bin/ruby

include_attribute "mon_zabbix_common"

default[:mon][:zabbix][:cloud30][:hadoop][:templates]= [ "Template_Hadoop_JobTracker", "Template_Hadoop_NameNode" ]
default[:mon][:zabbix][:cloud30][:hadoop][:entity_id]= "1234"
default[:mon][:zabbix][:cloud30][:hadoop][:key_prefix]= "hadoop"

default[:mon][:zabbix][:cloud30][:hadoop][:jobtrackernode][:zabbix_host]="#{node[:mon][:zabbix][:cloud30][:vm_name]}"
default[:mon][:zabbix][:cloud30][:hadoop][:jobtrackernode][:host]="1.2.3.4"
default[:mon][:zabbix][:cloud30][:hadoop][:jobtrackernode][:port]=50030

#must be specified in minutes
default[:mon][:zabbix][:cloud30][:hadoop][:jobtrackernode][:cron_duration]=1


default[:mon][:zabbix][:cloud30][:hadoop][:namenode][:zabbix_host]="#{node[:mon][:zabbix][:cloud30][:vm_name]}"
default[:mon][:zabbix][:cloud30][:hadoop][:namenode][:host]="1.2.3.4"
default[:mon][:zabbix][:cloud30][:hadoop][:namenode][:port]=50070

#must be specified in minutes
default[:mon][:zabbix][:cloud30][:hadoop][:namenode][:cron_duration]=1


default[:mon][:zabbix][:cloud30][:hadoop][:script_path]="/etc/zabbix/externalscripts"

