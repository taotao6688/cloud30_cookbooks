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

bash "expand_xt_file" do 
	user "root" 
	cwd "/var/package/filenet_fixpack/XT" 
	code <<-EOH 
	tar xvfz CI00MML.tar.gz
	#tar xvfz 1.1.5.2-WPXT-FP002-LINUX.tar.gz 
	EOH
end

template "/var/package/filenet_fixpack/XT/XT_silent_upgrade.txt" do
        source "fix_XT_silent_upgrade.erb"
        owner "root"
        group "root"
end

bash "uninstall_xt" do 
	user "root" 
	cwd "/var/package/filenet_fixpack/XT" 
	code <<-EOH 
	/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/wsadmin.sh -username P8Admin -password IBMFileNetP8 -lang jython -f /var/package/filenet_fixpack_script/uninstall_XT.py
	/opt/ibm/WebSphere/AppServer/bin/stopServer.sh server1 -username P8Admin -password IBMFileNetP8
	rm -rf /opt/IBM/WebSphere/AppServer/profiles/AppSrv01/temp/P8Node01/server1/WorkplaceXT
	rm -rf /opt/IBM/WebSphere/AppServer/profiles/AppSrv01/wstemp
	/opt/ibm/WebSphere/AppServer/bin/startServer.sh server1	
	cd /opt/ibm/FileNet/WebClient/deploy
	rm -rf web_client.ear
	rm -rf web_client.war
	EOH
end

bash "install_xt_fixpack" do 
	user "root" 
	cwd "/var/package/filenet_fixpack/XT/" 
	code <<-EOH 
	./WorkplaceXT-1.1.5.2-LINUX.bin -options "XT_silent_upgrade.txt" -silent
	EOH
end


bash "deploy_xt_fixpack" do 
	user "root" 
	cwd "/opt/ibm/FileNet/WebClient/deploy"
	code <<-EOH 
	rm -rf web_client.ear
	rm -rf web_client.war
	./create_web_client_war.sh
	/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/wsadmin.sh -username P8Admin -password IBMFileNetP8 -conntype SOAP -profileName AppSrv01 -lang jacl -f "/opt/IBM/cpit/install-scripts/deployXT.tcl"
	/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/wsadmin.sh -username P8Admin -password IBMFileNetP8 -lang jython -f /var/package/filenet_was.py
	/opt/ibm/WebSphere/AppServer/bin/stopServer.sh server1 -username P8Admin -password IBMFileNetP8
	/opt/ibm/WebSphere/AppServer/bin/startServer.sh server1	
	EOH
end

