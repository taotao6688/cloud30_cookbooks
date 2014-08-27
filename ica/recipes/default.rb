#
# Cookbook Name:: filenet
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

%w{ 
  libXmu 
}.each do |pkgname|
  package "#{pkgname}" do
      action :install
  end
end

%w{ 
  compat-libstdc++-33
  libstdc++ 
  zlib-devel
  libXext
  libXft
  libXi
  libXp
  libXtst
}.each do |pkgname|
  yum_package "#{pkgname}" do
      arch "i686"
      action :install
  end
end


directory "/var/package" do
        owner "root"
	group "root"
	action :create
end

directory "/var/package/ica" do
        owner "root"
	group "root"
	action :create
end

remote_file "/var/package/ica/IBM_CAWES_V3.0_LINUX_ML.tar" do
  source "#{node["ica"]["url"]}/IBM_CAWES_V3.0_LINUX_ML.tar"
end

bash "expand_files" do 
	user "root" 
	cwd "/var/package/ica" 
	code <<-EOH 
	tar xvf IBM_CAWES_V3.0_LINUX_ML.tar
	EOH
end

template "/var/package/ica/Main/responseFiles/LinuxMasterAllInOneServer.properties" do
        source "LinuxMasterAllInOneServer.erb"
        owner "root"
        group "root"
        variables({
                :hostname => node[:fqdn]  
	})
end


execute "execute_ica_install" do
  timeout 7200
  command "su -l -c 'cd /var/package/ica/Main  &&  ./install.bin -i silent -f responseFiles/LinuxMasterAllInOneServer.properties'"
  action :run
end

bash "start_ica" do 
	user "root" 
	code <<-EOH 
	su - esadmin -l -c '/opt/IBM/es/bin/esadmin system startall || echo'
	EOH
end
