#
# Cookbook Name:: mon_zabbix_agent
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

directory "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}" do
    owner "zabbix"
    group "zabbix"
    mode "0655"
    recursive true
    action :create
end

cookbook_file "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/ZabbixAPI.tgz" do
    source "ZabbixAPI.tgz"
    mode "0755" 
end

cookbook_file "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/#{node[:mon][:zabbix][:cloud30][:zabbix][:agent_installer]}" do
    source "#{node[:mon][:zabbix][:cloud30][:zabbix][:agent_installer]}"
    mode "0755" 
end

cookbook_file "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/#{node[:mon][:zabbix][:cloud30][:zabbix][:sender_installer]}" do
    source "#{node[:mon][:zabbix][:cloud30][:zabbix][:sender_installer]}"
    mode "0755"
end

cookbook_file "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/#{node[:mon][:zabbix][:cloud30][:zabbix][:zabbix_installer]}" do
    source "#{node[:mon][:zabbix][:cloud30][:zabbix][:zabbix_installer]}"
    mode "0755"
end

bash "Install Zabbix API" do
    user "root"
    cwd "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}"
    code <<-EOH
    tar -xzvf ZabbixAPI.tgz
    cd ZabbixAPI
    python setup.py install >> "#{node[:mon][:zabbix][:cloud30][:log_file]}"
    EOH
    action :run
end


rpm_package "#{node[:mon][:zabbix][:cloud30][:zabbix][:sender_installer]}" do
  source "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/#{node[:mon][:zabbix][:cloud30][:zabbix][:sender_installer]}"
  not_if "rpm -qa | grep -qa #{node[:mon][:zabbix][:cloud30][:zabbix][:sender_installer]}"
  action :install
end

rpm_package "#{node[:mon][:zabbix][:cloud30][:zabbix][:zabbix_installer]}" do
  source "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/#{node[:mon][:zabbix][:cloud30][:zabbix][:zabbix_installer]}"
  not_if "rpm -qa | grep -qa #{node[:mon][:zabbix][:cloud30][:zabbix][:zabbix_installer]}"
  action :install
end

rpm_package "#{node[:mon][:zabbix][:cloud30][:zabbix][:agent_installer]}" do
  source "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}/#{node[:mon][:zabbix][:cloud30][:zabbix][:agent_installer]}"
  not_if "rpm -qa | grep -qa #{node[:mon][:zabbix][:cloud30][:zabbix][:agent_installer]}"
  action :install
end



#bash "Install Zabbix Agent" do
#    user "root"
#    cwd "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}"
#    code <<-EOH
#    rpm -ivh "#{node[:mon][:zabbix][:cloud30][:zabbix_agent][:agent_installer]}"
#    adduser zabbix
#    echo `zabbix_agent 10050/tcp' >> /etc/services
#    echo `zabbix_trap 10051/tcp' >> /etc/services
#    chkconfig iptables off >> /tmp/zabbix.log
#    chkconfig ip6tables off >> /tmp/zabbix.log
#    rpm -ivh "#{node[:mon][:zabbix][:cloud30][:zabbix_agent][:sender_installer]}"
#    /etc/init.d/zabbix_agentd start
#    EOH
#end
