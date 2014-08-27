

template "#{Chef::Config[:file_cache_path]}/installer.properties" do
  source "installer.properties.erb"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['spss_modeler']['default_pkg']}" do
  source "#{node['spss_modeler']['source_path']}/#{node['spss_modeler']['default_pkg']}"
  mode 00755
end	
 
execute "install-spss_modeler" do
  cwd Chef::Config[:file_cache_path]
  command "./#{node['spss_modeler']['default_pkg']} -f installer.properties "
end

template "/etc/init.d/spss_modeler" do
    source 'init.erb'
    owner 'root'
    group 'root'
    mode 00755
  notifies :restart, 'service[spss_modeler]'
end

service 'spss_modeler' do  
  supports :restart => true, :status => true
  action [:enable, :start]
end






