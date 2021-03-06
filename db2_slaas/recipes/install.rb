#
# Cookbook Name:: db2
# Recipe:: install
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#

db2 "install db2" do
  version             node['db2']['version']
  prod                node['db2']['prod']
  package             node['db2']['package']
  port                node['db2']['port']
  fcm_port            node['db2']['fcm_port']
  max_logical_nodes   node['db2']['max_logical_nodes']
  instance_type       node['db2']['instance_type']
  instance_home_dir   node['db2']['instance_home_dir']
  instance_username   node['db2']['instance_username']
  instance_password   node['db2']['instance_password']
  fenced_username     node['db2']['fenced_username']
  fenced_password     node['db2']['fenced_password']
  das_username        node['db2']['das_username']
  das_password        node['db2']['das_password']
  req_packages        node['db2']['req_packages']
  action :install
end
