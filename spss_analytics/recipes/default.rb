


template "#{Chef::Config[:file_cache_path]}/installer.properties" do
  source "installer.properties.erb"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['spss_analytics']['default_pkg']}" do
 	 source "#{node['spss_analytics']['source_path']}/#{node['spss_analytics']['default_pkg']}"
	mode 00755
 end


bash "install" do
  user "root"
   cwd Chef::Config[:file_cache_path]
  code <<-EOH
 
  	tar -zxf #{node['spss_analytics']['default_pkg']}
	
	chmod +x #{Chef::Config[:file_cache_path]}/AnalyticServer/linux64/install.bin 

  	AnalyticServer/linux64/install.bin -f #{Chef::Config[:file_cache_path]}/installer.properties >> /tmp/text.log
  EOH
end
 

template "/etc/init.d/spss_analytics" do
    source 'init.erb'
    owner 'root'
    group 'root'
    mode 00755
 end

service 'spss_analytics' do  
  supports :restart => true, :status => true
  action [:enable, :start]
end






