#
# Cookbook Name:: filenet
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute

remote_file "/var/package/filenet_was.py" do
  source " #{node["filenet"]["url"]}/filenet/filenet_was.py"
end

bash "was_setting" do 
	user "root" 
	cwd "/var/package" 
	code <<-EOH 
	sed -i 's/com.ibm.CSI.performTransportAssocSSLTLSRequired=true/com.ibm.CSI.performTransportAssocSSLTLSRequired=false/' /opt/IBM/WebSphere/AppServer/profiles/AppSrv01/properties/sas.client.props
	/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/bin/wsadmin.sh -username P8Admin -password IBMFileNetP8 -lang jython -f ./filenet_was.py
	/opt/ibm/WebSphere/AppServer/bin/stopServer.sh server1 -username P8Admin -password IBMFileNetP8
	/opt/ibm/ldap/V6.3/sbin/ibmslapd -k
	su - dsrdbm01 -c db2stop
	su - dsrdbm01 -c db2start
	/opt/ibm/ldap/V6.3/sbin/ibmslapd -I dsrdbm01
	/opt/ibm/WebSphere/AppServer/bin/startServer.sh server1 
	EOH
end

