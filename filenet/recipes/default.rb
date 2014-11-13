#
# Cookbook Name:: filenet
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

bash "yum_update" do 
	user "root" 
	code <<-EOH 
	yum update -y 
	EOH
end

%w{ 
  gtk2 
  compat-libstdc++-33 
  ksh 
  rsh-server 
  nfs-utils  
  compat-db  
  gtk2-engines 
  libXp 
  libXmu 
  libXtst 
  pam 
  gcc
  kernel-devel 
  java-1.7.0-openjdk  
  java-1.7.0-openjdk-devel 
}.each do |pkgname|
  package "#{pkgname}" do
      action :install
  end
end

%w{ 
  gtk+extra
  compat-libstdc++-33
  pam
  compat-db
  libstdc++
  libXp
  libXmu
  libXtst
  libXft
  gtk2
  gtk2-engines
  compat-libstdc++-296
  PackageKit-gtk-module
  libcanberra-gtk2
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

directory "/opt/IBM" do
        owner "root"
	group "root"
	action :create
end

link "/opt/ibm" do
	to "/opt/IBM"
end

bash "setup_env" do 
	user "root" 
	code <<-EOH 
	sed -i 's/xpanel/#xpanel/' /etc/services
	echo "DB2_dsrdbm01 60000/tcp" >> /etc/services
	echo "DB2_dsrdbm01_1 60001/tcp" >> /etc/services
	echo "DB2_dsrdbm01_2 60002/tcp" >> /etc/services
	echo "DB2_dsrdbm01_END 60003/tcp" >> /etc/services
	echo "dsrdbm01svcids 3737/tcp" >> /etc/services
	echo "dsrdbm01svcidsi 3766/tcp" >> /etc/services
	EOH
end


remote_file "/var/package/filenet.tar" do
  source "#{node["filenet"]["url"]}/filenet.tar"
end

bash "expand_files" do 
	user "root" 
	cwd "/var/package" 
	code <<-EOH 
	tar xvf filenet.tar
	cd filenet
	tar xvfz CPIT_5.2_LINUX_EN.tar.gz
	curl -O #{node["filenet"]["url"]}/filenet/cpit.properties 
	curl -O #{node["filenet"]["url"]}/filenet/cpit_silent_install.txt
	cd install-scripts 
	curl -O #{node["filenet"]["url"]}/filenet/setDB2port.sh
	chmod +x setDB2port.sh 
	EOH
end


execute "execute_filenet_install" do
  timeout 7200
  command "su -l -c 'cd /var/package/filenet  && ./5.2.0-CPIT-LINUX.BIN -i silent -f ./cpit_silent_install.txt'"
  action :run
end
