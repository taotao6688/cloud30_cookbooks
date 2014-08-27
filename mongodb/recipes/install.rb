# install the 10gen repo if necessary
include_recipe 'mongodb::10gen_repo' if node['mongodb']['install_method'] == '10gen'

# prevent-install defaults, but don't overwrite
file node['mongodb']['sysconfig_file'] do
  content 'ENABLE_MONGODB=no'
  group node['mongodb']['root_group']
  owner 'root'
  mode 0644
  action :create_if_missing
end

# just-in-case config file drop
template node['mongodb']['dbconfig_file'] do
  cookbook node['mongodb']['template_cookbook']
  source node['mongodb']['dbconfig_file_template']
  group node['mongodb']['root_group']
  owner 'root'
  mode 0644
  variables(
    :config => node['mongodb']['config']
  )
  action :create_if_missing
end

# and we install our own init file
if node['mongodb']['apt_repo'] == 'ubuntu-upstart'
  init_file = File.join(node['mongodb']['init_dir'], "#{node['mongodb']['default_init_name']}.conf")
  mode = '0644'
else
  init_file = File.join(node['mongodb']['init_dir'], "#{node['mongodb']['default_init_name']}")
  mode = '0755'
end

template "#{node['mongodb']['repo_dir']}/#{node['mongodb']['name']}" do
    source 'repo.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
   
  end

template init_file do
  cookbook node['mongodb']['template_cookbook']
  source node['mongodb']['init_script_template']
  group node['mongodb']['root_group']
  owner 'root'
  mode mode
  variables(
    :provides =>       'mongod',
    :sysconfig_file => node['mongodb']['sysconfig_file'],
    :ulimit =>         node['mongodb']['ulimit'],
    :bind_ip =>        node['mongodb']['config']['bind_ip'],
    :port =>           node['mongodb']['config']['port']
  )
  action :create_if_missing
end
case node['platform_family']
	
when 'rhel'
        node['mongodb']['default_pkg'].each do |pkg|
      package pkg do
    action :install
    retries 5
     retry_delay 10
    end
    end
#end
end

node.set['mongodb']['source_path']=nil




# Create keyFile if specified
if node[:mongodb][:key_file_content]
  file node[:mongodb][:config][:keyFile] do
    owner node[:mongodb][:user]
    group node[:mongodb][:group]
    mode  '0600'
    backup false
    content node[:mongodb][:key_file_content]
  end
end
