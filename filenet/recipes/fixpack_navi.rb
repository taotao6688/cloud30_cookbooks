#
# Cookbook Name:: filenet
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute


bash "expand_navi_file" do 
	user "root" 
	cwd "/var/package/filenet_fixpack/NAVI"
	code <<-EOH 
	tar xvf IBM_CTNT_NAVI_2.0.2_LIN_ML.tar
	EOH
end

template "/var/package/filenet_fixpack/NAVI/ecmclient_silent_install.txt" do
        source "fix_ecmclient_silent_install.erb"
        owner "root"
        group "root"
end

bash "uninstall_navi" do 
	user "root" 
	cwd "/var/package/filenet_fixpack/NAVI/" 
	code <<-EOH 
	/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/wsadmin.sh -username P8Admin -password IBMFileNetP8 -lang jython -f /var/package/filenet_fixpack_script/uninstall_NAVI.py
	/opt/ibm/WebSphere/AppServer/bin/stopServer.sh server1 -username P8Admin -password IBMFileNetP8
	rm -rf /opt/IBM/WebSphere/AppServer/profiles/AppSrv01/temp/P8Node01/server1/navigator
	/opt/ibm/WebSphere/AppServer/bin/startServer.sh server1	
	EOH
end

bash "install_navi_fixpack" do 
	user "root" 
	cwd "/var/package/filenet_fixpack/NAVI/" 
	code <<-EOH 
	./IBM_CONTENT_NAVIGATOR-2.0.2-LINUX.bin -f ecmclient_silent_install.txt -i silent
	EOH
end


bash "deploy_navi_fixpack" do 
	user "root" 
	cwd "/opt/ibm/ECMClient/configure"
	code <<-EOF 
	 ./configmgr_cl generateConfig -appserver websphere  -configure_FileNetP8 yes -configure_CM no -configure_CMOD no -configure_CMIS_CM no -configure_CMIS_FileNetP8 no -db db2 -icn_sso none -deploy standard  -ldap_Repository standalone  -ldap tivoli  -profile /opt/ibm/cpit/install-scripts/profiles/NexusConfig
	 sed -i "s$<value>\\*\\*\\*\\*INSERT VALUE\\*\\*\\*\\*</value>$<value>NEXUS</value>$" /opt/IBM/cpit/install-scripts/profiles/NexusConfig/configureicntask.xml
	./configmgr_cl execute -task configureicntask -profile /opt/ibm/cpit/install-scripts/profiles/NexusConfig
	./configmgr_cl execute -task rebuildear -profile /opt/ibm/cpit/install-scripts/profiles/NexusConfig
	./configmgr_cl execute -task deployapplication -profile /opt/ibm/cpit/install-scripts/profiles/NexusConfig
	/opt/ibm/WebSphere/AppServer/bin/stopServer.sh server1 -username P8Admin -password IBMFileNetP8
	/opt/ibm/WebSphere/AppServer/bin/startServer.sh server1
	EOF
end

