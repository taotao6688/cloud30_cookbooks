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

remote_file "/var/package/filenet_fixpack.tar" do
  source "#{node["filenet"]["url"]}/filenet_fixpack.tar"
end

remote_file "/var/package/filenet_fixpack_script.tgz" do
  source "#{node["filenet"]["url"]}/filenet_fixpack_script.tgz"
end

bash "expand_cpe_files" do 
	user "root" 
	cwd "/var/package" 
	code <<-EOH 
	tar xvf filenet_fixpack.tar
	tar xvfz filenet_fixpack_script.tgz
	cd filenet_fixpack/CPE
	tar xvfz 5.2.0.3-P8CPE-LINUX-IF003.tar.gz
	EOH
end

template "/var/package/filenet_fixpack/CPE/ce_silent_install.txt" do
        source "fix_ce_silent_install.erb"
        owner "root"
        group "root"
end

bash "uninstall_cpe" do 
	user "root" 
	cwd "/var/package/filenet_fixpack/CPE/" 
	code <<-EOH 
	/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/wsadmin.sh -username P8Admin -password IBMFileNetP8 -lang jython -f /var/package/filenet_fixpack_script/uninstall_CE.py
	/opt/ibm/WebSphere/AppServer/bin/stopServer.sh server1 -username P8Admin -password IBMFileNetP8
	rm -rf /opt/IBM/WebSphere/AppServer/profiles/AppSrv01/temp/P8Node01/server1/FileNetEngine
	/opt/ibm/WebSphere/AppServer/bin/startServer.sh server1	
	EOH
end

bash "install_cpe_fixpack" do 
	user "root" 
	cwd "/var/package/filenet_fixpack/CPE/" 
	code <<-EOH 
	 ./5.2.0.3-P8CPE-LINUX-IF003.BIN -i silent -f ce_silent_install.txt
	EOH
end


bash "deploy_cpe_fixpack" do 
	user "root" 
	cwd "/opt/IBM/FileNet/ContentEngine/tools/configure"
	code <<-EOH 
	sed -i 's$<value>8.0</value>$<value>8.5</value>$' /opt/IBM/cpit/install-scripts/profiles/DeployCE/applicationserver.xml
	./configmgr_cl generateupgrade -server DeployCE -profile /opt/IBM/cpit/install-scripts/profiles/DeployCE -silent
	./configmgr_cl execute -task configurebootstrap -profile /opt/IBM/cpit/install-scripts/profiles/DeployCE -silent
	./configmgr_cl execute -task deployapplication -profile /opt/IBM/cpit/install-scripts/profiles/DeployCE -silent
	/opt/ibm/WebSphere/AppServer/bin/stopServer.sh server1 -username P8Admin -password IBMFileNetP8
	/opt/ibm/WebSphere/AppServer/bin/startServer.sh server1
	EOH
end

