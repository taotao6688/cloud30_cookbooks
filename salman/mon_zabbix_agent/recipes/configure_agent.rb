

directory "/etc/zabbix" do
    owner "zabbix"
    group "zabbix"
    mode "0655"
    recursive true
    action :create
end

template "/etc/zabbix/zabbix_agentd.conf" do
    path "/etc/zabbix/zabbix_agentd.conf"
    source "zabbix_agentd.conf.erb"
    owner "root"
    group "root"
    mode "0644"
    action :create
end

user "zabbix" do
  action :create
end

bash "configure zabbix_service" do
  user "root"
  cwd "#{node[:mon][:zabbix][:cloud30][:zabbix][:workdir]}"
  code <<-EOH
  echo 'zabbix_agent 10050/tcp' >> /etc/services
  echo 'zabbix_trap 10051/tcp' >> /etc/services
  EOH
end

service "zabbix-agent" do
  action [:enable, :start]
end


service "zabbix-agent" do
  action [:enable, :start]
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
