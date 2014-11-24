#
# Cookbook Name:: ucd_environment_addProperty
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#bash "Add Property to the environment" do
#  user "root"
#  cwd "/root"
#  code <<-EOH
#  ./udclient/udclient -weburl http://$UDEPLOY_SERVER:8080/ -username admin -password admin setEnvironmentProperty -environment $env_name -application "App_SWF" -name bi_server_hostname -value $(hostname)
#  EOH
#end

bash "Add Property to the environment" do
  user "root"
  cwd "/root"
  code <<-EOH
  export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64
  ./udclient/udclient -weburl #{node['udeploy']['server']['url']} -username #{node['udeploy']['user_name']} -password #{node['udeploy']['password']} setEnvironmentProperty -environment #{node['udeploy']['environment']} -application #{node['udeploy']['application']} -name #{node['udeploy']['property']['name']} -value #{node['udeploy']['property']['value']}
  EOH
end
