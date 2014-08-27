


template "#{Chef::Config[:file_cache_path]}/installer.properties" do
  source "installer.properties.erb"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['spss_modeler_batch']['default_pkg']}" do
  source "#{node['spss_modeler_batch']['source_path']}/#{node['spss_modeler_batch']['default_pkg']}"
  mode 00755
end	
 
execute "install-spss_modeler_batch" do
  cwd Chef::Config[:file_cache_path]
  command "./#{node['spss_modeler_batch']['default_pkg']} -f installer.properties "
end








