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

bash "expand_cpec_files" do 
	user "root" 
	cwd "/var/package" 
	code <<-EOH 
	cd filenet_fixpack/CPEC
	tar xvfz 5.2.0.3-P8CPE-CLIENT-LINUX-IF003.tar.gz
	EOH
end

template "/var/package/filenet_fixpack/CPEC/ceclient_silent_install.txt" do
        source "fix_ceclient_silent_install.erb"
        owner "root"
        group "root"
end


bash "install_cpec_fixpack" do 
	user "root" 
	cwd "/var/package/filenet_fixpack/CPEC/" 
	code <<-EOH 
	 ./5.2.0.3-P8CPE-CLIENT-LINUX-IF003.BIN -f ceclient_silent_install.txt -i silent
	EOH
end

