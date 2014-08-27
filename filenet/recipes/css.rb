#
# Cookbook Name:: filenet
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute


directory "/var/package/css" do
        owner "root"
	group "root"
	action :create
end


remote_file "/var/package/css/FN_CSS_5.2_LINUX_64_ML.tar.gz" do
  source "#{node["filenet"]["url"]}/FN_CSS_5.2_LINUX_64_ML.tar.gz"
end

bash "expand_css_files" do 
	user "root" 
	cwd "/var/package/css" 
	code <<-EOH 
	tar xvfz FN_CSS_5.2_LINUX_64_ML.tar.gz
	curl -O #{node["filenet"]["url"]}/filenet/css_silent_install.txt
	EOH
end


execute "execute_css_install" do
  timeout 7200
  command "su -l -c 'cd /var/package/css && ./5.2.0-CSS-LINUX64.bin -i silent -f ./css_silent_install.txt'"
  action :run
end
