bash "setup_was_profile" do
        user "mdmadmin"
        group "mdmadmin"
        code <<-EOH
	/opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh -create -profileName Dmgr01  -profilePath /opt/IBM/WebSphere/AppServer/profiles/Dmgr01 -templatePath /opt/IBM/WebSphere/AppServer/profileTemplates/management -nodeName Node001 -cellName CellManager001 -hostName localhost -enableAdminSecurity true -adminUserName mdmadmin -adminPassword mdmadmin
	/opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh -validateAndUpdateRegistry

	PROP_PATH=/opt/IBM/WebSphere/AppServer/profiles/Dmgr01/properties/
	sed 's/com.ibm.SOAP.requestTimeout=180/com.ibm.SOAP.requestTimeout=1800/g' $PROP_PATH/soap.client.props > $PROP_PATH/soap.client.props.tmp && mv -f $PROP_PATH/soap.client.props.tmp $PROP_PATH/soap.client.props

	/opt/IBM/WebSphere/AppServer/bin/startManager.sh -profileName Dmgr01 -username mdmadmin -password mdmadmin

	port=$(cat /opt/IBM/WebSphere/AppServer/profiles/Dmgr01/logs/AboutThisProfile.txt | grep "Management SOAP connector port" | sed 's/Management SOAP connector port: //g')
	/opt/IBM/WebSphere/AppServer/bin/manageprofiles.sh -create -profileName AppSrv01 -profilePath /opt/IBM/WebSphere/AppServer/profiles/AppSrv01 -templatePath /opt/IBM/WebSphere/AppServer/profileTemplates/managed -hostName localhost -nodeName AppSrv01 -cellName cell001 -dmgrHost localhost -dmgrPort $port -dmgrAdminUserName mdmadmin -dmgrAdminPassword mdmadmin

	sed 's/com.ibm.SOAP.requestTimeout=180/com.ibm.SOAP.requestTimeout=1800/g' $PROP_PATH/soap.client.props > $PROP_PATH/soap.client.props.tmp && mv -f $PROP_PATH/soap.client.props.tmp $PROP_PATH/soap.client.props
	
        EOH
end

remote_file "/var/package/mdm.tgz" do
  source "#{node["mdm"]["url"]}/mdm.tgz"
  user "mdmadmin"
  group "mdmadmin"
end

bash "expand_mdm" do
	user "mdmadmin"
	group "mdmadmin"
        cwd "/var/package"
        code <<-EOH
        tar zxvf mdm.tgz
        EOH
end

remote_file "/var/package/mdm/mdm_advanced_disks.zip" do
  source "#{node["mdm"]["url"]}/mdm_advanced_disks.zip"
  user "mdmadmin"
  group "mdmadmin"
end


bash "setup_was" do
  	user "mdmadmin"
	group "mdmadmin"
        cwd "/var/package/mdm"
        code <<-EOH
	WAS_PROFILE_ROOT=/opt/IBM/WebSphere/AppServer CELL_NAME=CellManager001 SERVER_NAME=server1 ./environmentSetting.sh
	EOH
end
bash "setup_db2" do
        user "root"
        cwd "/var/package/mdm"
        code <<-EOH
	RemoteDatabase_HostIP=#{node["mdm"]["dbip"]} RemoteDatabase_Port=50000 ./catalogDB.sh
	./setupDB.sh
	EOH
end

bash "genereate_files" do
  	user "mdmadmin"
	group "mdmadmin"
        cwd "/var/package/mdm"
        code <<-EOH
	RemoteDatabase_HostIP=#{node["mdm"]["dbip"]} RemoteDatabase_Port=50000 WAS_INSTALL_ROOT=/opt/IBM/WebSphere/AppServer/ WAS_PORT=8879 HOSTNAME=localhost NODE_NAME=Node001 CELL_NAME=CellManager001 WAS_PROFILE_ROOT=/opt/IBM/WebSphere/AppServer/profiles/Dmgr01 ./generateResponseFile.sh
	./createInstallationForMDM.sh
	EOH
end

