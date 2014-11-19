#
# Cookbook Name:: filenet
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

%w{ 
  ld-linux.so.2
}.each do |pkgname|
  package "#{pkgname}" do
      action :install
  end
end

%w{ 
 libgcc
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

directory "/var/package/ica_cec" do
        owner "root"
	group "root"
	action :create
end

remote_file "/var/package/ica_cec/FN_CEC_5.2_LINUX_EN.tar.gz" do
  source "#{node["ica"]["url"]}/FN_CEC_5.2_LINUX_EN.tar.gz"
end

bash "expand_files" do 
	user "root" 
	cwd "/var/package/ica_cec" 
	code <<-EOH 
	tar xvfz FN_CEC_5.2_LINUX_EN.tar.gz 
	EOH
end


template "/var/package/ica_cec/ceclient_silent_install.txt" do
        source "ceclient_silent_install.erb"
        owner "root"
        group "root"
end


execute "execute_cec_install" do
  timeout 7200
  command "cd /var/package/ica_cec &&  ./5.2.0-P8CE-CLIENT-LINUX.BIN -i silent -f ceclient_silent_install.txt || echo"
  action :run
end

bash "start_cec" do 
	user "root" 
	code <<-EOH 
	su - esadmin -l -c 'echo "/opt/IBM/FileNet/CEClient" | /opt/IBM/es/bin/escrfilenet.sh'
	su - esadmin -l -c '/opt/IBM/es/bin/esadmin system stopall || echo'
	su - esadmin -l -c '/opt/IBM/es/bin/esadmin system startall || echo'
	EOH
end
