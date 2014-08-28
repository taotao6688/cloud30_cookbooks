#
# Cookbook Name:: tomcat
# Recipe:: default
#
# Copyright 2010, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# required for the secure_password method from the openssl cookbook
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

include_recipe 'java'

tomcat_pkgs = value_for_platform(
  ['smartos'] => {
    'default' => ['apache-tomcat'],
  },
  'default' => ["tomcat#{node['tomcat']['base_version']}"]
  )
if node['tomcat']['deploy_manager_apps']
  tomcat_pkgs << value_for_platform(
    %w{ debian  ubuntu } => {
      'default' => "tomcat#{node['tomcat']['base_version']}-admin",
    },
    %w{ centos redhat fedora amazon } => {
      'default' => "tomcat#{node['tomcat']['base_version']}-admin-webapps",
    }
    )
end

tomcat_pkgs.compact!



tomcat_pkgs.each do |pkg|
  #package pkg do
   # action :install
   # version node['tomcat']['base_version'].to_s if platform_family?('smartos')
  #end
  
  #['tomcat']['base']
  
  remote_file "#{Chef::Config[:file_cache_path]}/#{node['tomcat']['tomcat_tar']}" do
	source "#{node['tomcat']['source_path']}/#{node['tomcat']['tomcat_tar']}"
	mode 00755
	notifies :create, "directory[create-tomcat-home]", :immediately
	notifies :run, "execute[untar-tomcat]", :immediately
	#notifies :run, "execute[copy-init]", :immediately
	#notifies :run, "execute[perm-init]", :immediately
  end
  
end

directory "create-tomcat-home" do
  path node['tomcat']['config_dir']	
  mode '0755'
  recursive true
end

execute "untar-tomcat" do

      user 'root'
      cwd Chef::Config[:file_cache_path]
      command " tar xzf #{Chef::Config[:file_cache_path]}/#{node['tomcat']['tomcat_tar']} -C #{node['tomcat']['config_dir']} --strip 1; "
	  
end



directory node['tomcat']['endorsed_dir'] do
  mode '0755'
  recursive true
end

unless node['tomcat']['deploy_manager_apps']
  directory "#{node['tomcat']['webapp_dir']}/manager" do
    action :delete
    recursive true
  end
  file "#{node['tomcat']['config_dir']}/Catalina/localhost/manager.xml" do
    action :delete
  end
  directory "#{node['tomcat']['webapp_dir']}/host-manager" do
    action :delete
    recursive true
  end
  file "#{node['tomcat']['config_dir']}/Catalina/localhost/host-manager.xml" do
    action :delete
  end
end

node.set_unless['tomcat']['keystore_password'] = secure_password
node.set_unless['tomcat']['truststore_password'] = secure_password

unless node['tomcat']['truststore_file'].nil?
  java_options = node['tomcat']['java_options'].to_s
  java_options << " -Djavax.net.ssl.trustStore=#{node['tomcat']['config_dir']}/#{node['tomcat']['truststore_file']}"
  java_options << " -Djavax.net.ssl.trustStorePassword=#{node['tomcat']['truststore_password']}"

  node.set['tomcat']['java_options'] = java_options
end



case node['platform']


when 'centos', 'redhat', 'fedora', 'amazon'

Chef::Log.warn("Using java::default instead is recommended.111")
  template "/etc/sysconfig/tomcat#{node['tomcat']['base_version']}" do
    source 'sysconfig_tomcat7.erb'
    owner 'root'
    group 'root'
    mode '0644'
	Chef::Log.warn("Using java::default instead is recommended.222")
    #notifies :restart, 'service[tomcat]'
  end
when 'smartos'
  template "#{node['tomcat']['base']}/bin/setenv.sh" do
    source 'setenv.sh.erb'
    owner 'root'
    group 'root'
    mode '0644'
    #notifies :restart, 'service[tomcat]'
  end
else
  template "/etc/default/tomcat#{node['tomcat']['base_version']}" do
    source 'default_tomcat7.erb'
    owner 'root'
    group 'root'
    mode '0644'
    #notifies :restart, 'service[tomcat]'
  end
end


execute "copy-init" do

      user 'root'
	  command " cp /etc/sysconfig/tomcat#{node['tomcat']['base_version']} /etc/init.d/ "
	  
end

execute "perm-init" do

      user 'root'
	  command " chmod 755 /etc/init.d/tomcat#{node['tomcat']['base_version']}; "
	  
end
template "#{node['tomcat']['config_dir']}/server.xml" do
  source 'server.xml.erb'
  owner 'root'
  group 'root'
  mode '0644'
  #notifies :restart, 'service[tomcat]'
end

template "#{node['tomcat']['config_dir']}/logging.properties" do
  source 'logging.properties.erb'
  owner 'root'
  group 'root'
  mode '0644'
  #notifies :restart, 'service[tomcat]'
end

#service "tomcat" do
#  service_name "tomcat#{node['tomcat']['base_version']}"
#  supports :restart => true, :status => true  
#  action [:enable, :start]  
#end

bash "starting" do

  user "root"
  cwd "/etc/init.d"

  code <<-EOH
		export CATALINA_PID=/etc/tomcat#{node['tomcat']['base_version']}/catalina_pid.txt
        ./tomcat#{node['tomcat']['base_version']} start

  EOH
end
