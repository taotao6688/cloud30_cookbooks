#
# Cookbook Name:: mon_zabbix_agent
# Recipe:: process_os_agent
# 
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

logMsgInfo "zabbix host group - sol:name '#{node[:mon][:zabbix][:cloud30][:sol_name]}' sol_id: '#{node[:mon][:zabbix][:cloud30][:sol_id]}'"
    
node[:mon][:zabbix][:cloud30][:hadoop][:templates].each do |template|

  bash "associate template with host" do
    user "root"
    cwd "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}"
    logMsgInfo "#{template} #{node[:mon][:zabbix][:cloud30][:vm_name]} #{node[:mon][:zabbix][:cloud30][:vm_id]}"
    code <<-EOH
python associate_template.py -n "#{node[:mon][:zabbix][:cloud30][:vm_name]}" -i "#{node[:mon][:zabbix][:cloud30][:vm_id]}" -t "#{template}" >> "#{node[:mon][:zabbix][:cloud30][:log_file]}"
    EOH
    #ignore_failure true
    action :run
  end
end

bash "create zabbix entity" do
    user "root"
    cwd "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}"
    code <<-EOH
    python manage_application.py -c create -n "#{node[:mon][:zabbix][:cloud30][:vm_name]}" -i "#{node[:mon][:zabbix][:cloud30][:vm_id]}" -e "#{node[:mon][:zabbix][:cloud30][:hadoop][:entity_id]}" -m "#{node[:mon][:zabbix][:cloud30][:hadoop][:key_prefix]}" >> "#{node[:mon][:zabbix][:cloud30][:log_file]}"
    EOH
    #ignore_failure true
    action :run
end
