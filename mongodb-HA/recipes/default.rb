#
# Cookbook Name:: mongodb-HA
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#




run_file = "/tmp/run.sh"
run_file1="/tmp/test.js"

file run_file do
    action :delete
end


file run_file1 do
    action :delete
end

template "/tmp/run.sh" do
source "config.erb"
   owner "root"
    group "root"
    mode 0755
  end

cmd = "/tmp/run.sh \"#{node['replicasetName'] }\" \"#{ node['primary'] }\" \"#{ node['primary_port'] }\" \"#{ node['secondary'] }\" \"#{ node['secondary_port'] }\" \"#{ node['arbiter'] }\" \"#{ node['arbiter_port'] }\" \"/tmp/test.js\""
cmd1="mongo --port #{node['primary_port']} /tmp/test.js"
	bash "add" do
	  user "root"
	  cwd "/tmp"
	  code <<-EOH
	   
	   #{cmd} 
	   #{cmd1}
	   EOH
	end
node.set['replicasetName']=nil
node.set['primary']=nil
node.set['primary_port']=nil
node.set['arbiter']=nil
node.set['arbiter_port']=nil
node.set['secondary']=nil
node.set['secondary_port']=nil

