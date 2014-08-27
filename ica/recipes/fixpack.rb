#
# Cookbook Name:: filenet
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute


directory "/var/package/ica-fix" do
        owner "root"
	group "root"
	action :create
end

remote_file "/var/package/ica-fix/3.0.0-IS-ICAwES-Linux-FP0004.tar" do
  source "#{node["ica"]["url"]}/3.0.0-IS-ICAwES-Linux-FP0004.tar"
end

bash "expand_files" do 
	user "root" 
	cwd "/var/package/ica-fix" 
	code <<-EOH 
	tar xvf 3.0.0-IS-ICAwES-Linux-FP0004.tar
	EOH
end

template "/var/package/ica-fix/Main/responseFiles/LinuxUpdateInstall.properties" do
        source "LinuxUpdateInstall.erb"
        owner "root"
        group "root"
end

bash "stop_ica" do 
	user "root" 
	code <<-EOH 
	su - esadmin -l -c '/opt/IBM/es/bin/esadmin system stopall'
	su - esadmin -l -c '/opt/IBM/es/bin/stopccl.sh'
	su - esadmin -l -c '/opt/IBM/es/bin/startccl.sh -bg'
	EOH
end

execute "execute_icafix_install" do
  timeout 7200
  command "su -l -c 'cd /var/package/ica-fix/Main  &&  ./install.bin -i silent -f responseFiles/LinuxUpdateInstall.properties'"
  action :run
end

bash "start_ica" do 
	user "root" 
	code <<-EOH 
	su - esadmin -l -c '/opt/IBM/es/bin/stopccl.sh'
	su - esadmin -l -c '/opt/IBM/es/bin/startccl.sh -bg'
	su - esadmin -l -c '/opt/IBM/es/bin/esadmin system startall'
	EOH
end
