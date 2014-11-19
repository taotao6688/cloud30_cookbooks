#
# Cookbook Name:: filenet
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

remote_file "/var/package/LCH_pkg.tgz" do
  source " #{node["filenet"]["url"]}/LCH_pkg.tgz"
end

bash "db_create" do 
	user "root" 
	cwd "/var/package" 
	code <<-EOH 
	tar xvfz LCH_pkg.tgz
	cd LCH_pkg/Script
	./1_create_db.sh 
	EOH
end

