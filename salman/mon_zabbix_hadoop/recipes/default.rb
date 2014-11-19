#
# Cookbook Name:: zabbix-hadoop
# Recipe:: default
#
# Copyright 2014, IBM
#
# All rights reserved - Do Not Redistribute
#

directory "#{node[:mon][:zabbix][:cloud30][:hadoop][:script_path]}" do
  owner "zabbix"
  group "zabbix"
  mode "0655"
  action :create
end

template "#{node[:mon][:zabbix][:cloud30][:hadoop][:script_path]}/mikoomi-hadoop-jobtracker-plugin.sh" do
  source "mikoomi-hadoop-jobtracker-plugin.sh.erb"
  owner "root"
  group "root"
  mode "755"
end

template "#{node[:mon][:zabbix][:cloud30][:hadoop][:script_path]}/mikoomi-hadoop-jobtracker-plugin-helper.sh" do
  source "mikoomi-hadoop-jobtracker-plugin-helper.sh.erb"
  owner "root"
  group "root"
  mode "755"
end

template "#{node[:mon][:zabbix][:cloud30][:hadoop][:script_path]}/mikoomi-hadoop-namenode-plugin.sh" do
  source "mikoomi-hadoop-namenode-plugin.sh.erb"
  owner "root"
  group "root"
  mode "755"
end

template "#{node[:mon][:zabbix][:cloud30][:hadoop][:script_path]}/mikoomi-hadoop-namenode-plugin-helper.sh" do
  source "mikoomi-hadoop-namenode-plugin-helper.sh.erb"
  owner "root"
  group "root"
  mode "755"
end

template "#{node[:mon][:zabbix][:cloud30][:hadoop][:script_path]}/mikoomi-vars.sh" do
  source "mikoomi-vars.sh.erb"
  owner "root"
  group "root"
  mode "755"
end

template "#{node[:mon][:zabbix][:cloud30][:hadoop][:script_path]}/jobtracker-cron.sh" do
  source "jobtracker-cron.sh.erb"
  owner "root"
  group "root"
  mode "755"
end


template "#{node[:mon][:zabbix][:cloud30][:hadoop][:script_path]}/namenode-cron.sh" do
  source "namenode-cron.sh.erb"
  owner "root"
  group "root"
  mode "755"
end


bash "create_jobtracker_cron" do
code <<-EOF
( crontab -l 2>/dev/null | grep -Fv jobtracker-cron ; echo "*/#{node[:mon][:zabbix][:cloud30][:hadoop][:jobtrackernode][:cron_duration]} * * * * #{node[:mon][:zabbix][:cloud30][:hadoop][:script_path]}/jobtracker-cron.sh") | crontab
EOF
action :run
end


bash "create_namenode_cron" do
code <<-EOF
( crontab -l 2>/dev/null | grep -Fv namenode-cron ; echo "*/#{node[:mon][:zabbix][:cloud30][:hadoop][:namenode][:cron_duration]} * * * * #{node[:mon][:zabbix][:cloud30][:hadoop][:script_path]}/namenode-cron.sh") | crontab
EOF
action :run
end


