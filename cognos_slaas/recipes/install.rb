# 
# Cookbook Name:: cognos
# Recipe:: install
#
# Copyright 2013, IBM
#
# All rights reserved - Do Not Redistribute
#
cognos "install cognos" do
  version             node['cognos']['version']
  agreement           node['cognos']['license']['agreement']
  install_dir         node['cognos']['install_dir']
  bi_server           node['cognos']['bi_server']
  backup              node['cognos']['backup']
  application_tier    node['cognos']['application_tier']
  gateway             node['cognos']['gateway']
  content_manager     node['cognos']['content_manager']
  content_database    node['cognos']['content_database']
  req_packages        node['cognos']['req_packages']
  action :install
end
