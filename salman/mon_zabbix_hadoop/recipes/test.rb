Chef::Log.info(node['my_attribute'])

directory "#{node[:my_attribute]}" do
  owner "zabbix"
  group "zabbix"
  mode "0655"
  action :create
end

