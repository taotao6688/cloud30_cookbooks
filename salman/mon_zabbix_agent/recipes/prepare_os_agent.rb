#
# Cookbook Name:: mon_zabbix_agent
# Recipe:: process_os_agent
# 
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}" do
    owner "zabbix"
    group "zabbix"
    mode "0655"
    action :create
    recursive true
end

template "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}" do
    path "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/login.cfg"
    source "login.cfg.erb"
    owner "root"
    group "root"
    mode "0644"
    action :create
end

cookbook_file "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/manage_hostgroup.py" do
    source "manage_hostgroup.py"
    mode "0755" 
end

cookbook_file "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/manage_host.py" do
    source "manage_host.py"
    mode "0755" 
end

cookbook_file "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/manage_application.py" do
    source "manage_application.py"
    mode "0755" 
end

cookbook_file "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/associate_template.py" do
    source "associate_template.py"
    mode "0755"
end


logMsgInfo "zabbix host group - sol:name '#{node[:mon][:zabbix][:cloud30][:sol_name]}' sol_id: '#{node[:mon][:zabbix][:cloud30][:sol_id]}'"

bash "create zabbix host group" do
    user "root"
    cwd "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}"
    code <<-EOH
    python manage_hostgroup.py -c create -s "#{node[:mon][:zabbix][:cloud30][:sol_name]}" -d "#{node[:mon][:zabbix][:cloud30][:sol_id]}" >> "#{node[:mon][:zabbix][:cloud30][:log_file]}"
    EOH
    #ignore_failure true
    action :run
end


bash "create zabbix host" do
    user "root"
    cwd "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}"
    code <<-EOH
    python manage_host.py -c create -n "#{node[:mon][:zabbix][:cloud30][:vm_name]}" -i "#{node[:mon][:zabbix][:cloud30][:vm_id]}" -p "#{node[:mon][:zabbix][:cloud30][:vm_ip]}" -s "#{node[:mon][:zabbix][:cloud30][:sol_name]}" -d "#{node[:mon][:zabbix][:cloud30][:sol_id]}" >> "#{node[:mon][:zabbix][:cloud30][:log_file]}"
    EOH
    #ignore_failure true
    action :run
end


bash "create zabbix entity" do
    user "root"
    cwd "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}"
    code <<-EOH
    python manage_application.py -c create -n "#{node[:mon][:zabbix][:cloud30][:vm_name]}" -i "#{node[:mon][:zabbix][:cloud30][:vm_id]}" -e "#{node[:mon][:zabbix][:cloud30][:vm_id]}" >> "#{node[:mon][:zabbix][:cloud30][:log_file]}"
    #python manage_application.py -c create -n #{node[:mon][:zabbix][:cloud30][:vm_name]} -i #{node[:mon][:zabbix][:cloud30][:vm_id]} -e #{node[:mon][:zabbix][:cloud30][:vm_id]}" 
    EOH
    #ignore_failure true
    action :run
end
