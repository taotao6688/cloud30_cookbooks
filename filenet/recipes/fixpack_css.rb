#
# Cookbook Name:: filenet
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute


directory "/var/package" do
        owner "root"
	group "root"
	action :create
end

bash "expand_css_file" do 
	user "root" 
	cwd "/var/package/filenet_fixpack/CSS"
	code <<-EOH 
	tar xvfz 5.2.0.2-P8CSS-LINUX64-FP002.tar.gz
	EOH
end

template "/var/package/filenet_fixpack/CSS/css_silent_install.txt" do
        source "fix_css_silent_install.erb"
        owner "root"
        group "root"
end

bash "install_css_fixpack" do 
	user "root" 
	cwd "/var/package/filenet_fixpack/CSS" 
	code <<-EOH 
	 ./5.2.0.2-P8CSS-LINUX64.BIN -i silent -f css_silent_install.txt
	cd /opt/IBM/ContentSearchServices/CSS_Server/bin
	./shutdown.sh
	./startup.sh
	EOH
end
