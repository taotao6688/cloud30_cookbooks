
template "#{Chef::Config[:file_cache_path]}/installer.properties" do
  source "installer.properties.erb"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['spss_analytics']['default_pkg']}" do
 	 source "#{node['spss_analytics']['source_path']}/#{node['spss_analytics']['default_pkg']}"
	mode 00755
 end

 template "/etc/init.d/spss_analytics" do
    source 'init.erb'
    owner 'root'
    group 'root'
    mode 00755
 end
 

bash "install" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
	
	mkdir #{Chef::Config[:file_cache_path]}/spss_analytics
  	tar -zxf #{node['spss_analytics']['default_pkg']} -C #{Chef::Config[:file_cache_path]}/spss_analytics	 
	chmod +x #{Chef::Config[:file_cache_path]}/spss_analytics/AnalyticServer/linux64/install.bin 
	
  	spss_analytics/AnalyticServer/linux64/install.bin -f #{Chef::Config[:file_cache_path]}/installer.properties 
	
	chown -R #{node['spss_analytics']['username']}:#{node['spss_analytics']['username']} #{node['spss_analytics']['dirpath']}
	
  EOH
end

bash "cleanup" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
	
	rm -rf #{Chef::Config[:file_cache_path]}/spss_analytics
	rm -rf #{Chef::Config[:file_cache_path]}/installer.properties
	rm -f  #{Chef::Config[:file_cache_path]}/#{node['spss_analytics']['default_pkg']}
	
  EOH
end

service 'spss_analytics' do  
  start_command "su - #{node['spss_analytics']['username']} -c '/etc/init.d/spss_analytics start'"	
  stop_command  "su - #{node['spss_analytics']['username']} -c '/etc/init.d/spss_analytics stop'"	
  supports :restart => true, :status => true
  action [:enable, :start]
end