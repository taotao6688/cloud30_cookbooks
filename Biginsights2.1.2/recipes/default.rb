
remote_file "#{Chef::Config[:file_cache_path]}/#{node['biginsights']['default_pkg']}" do
 source "#{node['biginsights']['source_path']}/#{node['biginsights']['default_pkg']}"
  mode 00755
end

template "/tmp/ipv6" do
  source "disableIPv6.erb"
  owner "root"
  group "root"
  mode "0644" 
end

bash "Configuring" do
  user "root"
 cwd "#{Chef::Config[:file_cache_path]}"
  code <<-EOH
  service iptables stop
  echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
  echo 1 > /proc/sys/net/ipv6/conf/default/disable_ipv6
  cat /tmp/ipv6 >> /etc/sysctl.conf
  service iptables start
  service ntpd start
  chkconfig ntpd on
  tar -zxf #{node['biginsights']['default_pkg']}
  rm -rf #{node['biginsights']['default_pkg']}
  EOH
end

template "#{Chef::Config[:file_cache_path]}/#{node['biginsights']['default_dir']}/silent-install/fullinstall.xml" do
  source "fullinstall.erb"
  owner "root"
  group "root"
  mode "0644"
end

bash "Installing-Using-XML" do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}/#{node['biginsights']['default_dir']}/silent-install"
  code <<-EOH
	./silent-install.sh fullinstall.xml --uninstall
  EOH
end

template "/tmp/fixOozie.sh" do
  source "fixOozie.erb"
  owner "root"
  group "root"
  mode "0744"
end

bash "Fixing Oozie Server Bug" do
  user "root"
  cwd "/tmp"
  code <<-EOH
        ./fixOozie.sh
  EOH
end

