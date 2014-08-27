#
# Cookbook Name:: mongodb-HA
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
# command "mongo --eval 'rs.addArb( "#{hostname}" )'"




execute "add" do
    user 'root'
    cwd Chef::Config[:file_cache_path]
   command "mongo --eval 'rs.add(\"#{node['mongodb']['secondary']}\")'"
action :run
end