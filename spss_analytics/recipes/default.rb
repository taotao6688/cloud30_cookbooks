
template "#{Chef::Config[:file_cache_path]}/installer.properties" do
  source "installer.properties.erb"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['spss_analytics']['default_pkg']}" do
	source "#{node['spss_analytics']['source_path']}/#{node['spss_analytics']['default_pkg']}"
	mode 00755
end

execute "create_biadmin" do
    command "useradd biadmin"
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

  EOH
end


remote_file "#{Chef::Config[:file_cache_path]}/spss_analytics/#{node['spss_analytics']['req_lib_tar_gz']}" do
	source "#{node['spss_analytics']['source_path']}/#{node['spss_analytics']['req_lib_tar_gz']}"
	mode 00755
end

bash "Create Directory" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
	
	mkdir #{node['spss_analytics']['dirpath']}/bin/hadoop_setup/AE_HADOOP_LIB
    mkdir #{node['spss_analytics']['dirpath']}/bin/hadoop_setup/Apache_0.20_SRC
	
  EOH
end



template "#{node['spss_analytics']['dirpath']}/ae_wlpserver/usr/servers/aeserver/configuration/config.properties" do
    source 'config.erb'
    owner 'root'
    group 'root'
    mode 00755
end

template "#{node['spss_analytics']['dirpath']}/ae_wlpserver/usr/servers/aeserver/derby.properties" do
    source 'derby.properties.erb'
    owner 'root'
    group 'root'
    mode 00755
end

template "#{node['spss_analytics']['dirpath']}/ae_wlpserver/usr/servers/aeserver/server.xml " do
    source 'server.erb'
    owner 'root'
    group 'root'
    mode 00755
end


template "#{node['spss_analytics']['dirpath']}/bin/encHadoopPassword.properties " do
    source 'encHadoopPassword.properties.erb'
    owner 'root'
    group 'root'
    mode 00755
end


template "#{node['spss_analytics']['dirpath']}/bin/encKeystore.properties " do
    source 'encKeystore.properties.erb'
    owner 'root'
    group 'root'
    mode 00755
 end

template "#{node['spss_analytics']['dirpath']}/bin/encBasicRegPass.propeties " do
    source 'encBasicRegPass.propeties.erb'
    owner 'root'
    group 'root'
    mode 00755
 end

 
bash "install required libraries" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
	
	cd spss_analytics 
	tar -zxf #{node['spss_analytics']['req_lib_tar_gz']}
	
	cp commons-configuration-1.6.jar commons-io-2.1.jar commons-lang-2.4.jar core-site.xml hadoop-core-1.1.1.jar hadoop_ver_found.properties jackson-core-asl-1.8.8.jar jackson-mapper-asl-1.8.8.jar jersey-core-1.8.jar jersey-server-1.8.jar mapred-site.xml #{node['spss_analytics']['dirpath']}/bin/hadoop_setup/AE_HADOOP_LIB
	cp jersey-server-1.8.jar jersey-core-1.8.jar jackson-mapper-asl-1.8.8.jar hadoop-core-1.1.1.jar jackson-core-asl-1.8.8.jar commons-configuration-1.6.jar commons-io-2.1.jar commons-lang-2.4.jar #{node['spss_analytics']['dirpath']}/ae_wlpserver/usr/servers/aeserver/apps/AE_BOOT.war/WEB-INF/lib
	cp commons-io-1.4.jar #{node['spss_analytics']['dirpath']}/bin/hadoop_setup/Apache_0.20_SRC
	
	chown -R #{node['spss_analytics']['biginsights_user']}:#{node['spss_analytics']['biginsights_user']} #{node['spss_analytics']['dirpath']}
	
	cp #{node['spss_analytics']['dirpath']}/ae_wlpserver/usr/servers/aeserver/configuration/config.properties #{Chef::Config[:file_cache_path]}/spss_analytics/config.properties
	
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
  start_command "su - #{node['spss_analytics']['biginsights_user']} -c '/etc/init.d/spss_analytics start'"	
  stop_command  "su - #{node['spss_analytics']['biginsights_user']} -c '/etc/init.d/spss_analytics stop'"	
  supports :restart => true, :status => true
  action [:enable, :start]
end
