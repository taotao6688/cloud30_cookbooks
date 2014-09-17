SPSS Analytics Server Cookbook
=============================
Installs and configures SPSS  Analytics Server v1.0.1.0.112


Requirements
------------
### Platform
- Red Hat Enterprise Linux 6.5 for 64-bit x64 (kernel 2.6.32-431)


### Installable 
- Please make sure, `anl_svr_1.0.1.0_l86_en_.tar.gz` is available for installation over HTTP URL as `http://0.0.0.0/`


Usage
-----
You need to create role specific to SPSS Analytics Server before starting cookbook execution.

Create role with command :  knife role create role_spss_analytics

Please make sure, role definition looks like

 {
	"name": "role_spss_analytics",
  	"description": "SPSS Analytics Server Cookbook",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": ["recipe[spss_analytics]"
  	],

  	 "env_run_lists": {
  	}
 }


	 
-  Once role is created, bootstrap the node as

	knife bootstrap <IP> -x root -P <password> -r role[role_spss_analytics] -d <distribution>  -j '{"spss_analytics": {"source_path":"URL","dirpath":"spss_analytics_server_home"}}'		
	
	where
		IP : IP address of node where SPSS analytics Server need to install
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : HTTP path mentioned in `Installable` section
		spss_analytics_server_home : SPSS Analytics Server Home Directory.
		
- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.

		IP : 172.16.1.152 (Target Node for SPSS Analytics Server installation)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		source_path : http://172.16.1.153 (So if you hit "http://172.16.1.153/anl_svr_1.0.1.0_l86_en_.tar.gz" from browser, you should able to download this file)
		dirpath : /opt/IBM/SPSS/AnalyticsServer/1.0.1

		
		So user can run command like
		
		knife bootstrap 172.16.1.152 -x root -P test4pass -r role[role_spss_analytics] -d rhel -j '{"spss_analytics": {"source_path":"http://172.16.1.153","dirpath":"/opt/IBM/SPSS/AnalyticsServer/1.0.1"}}'		
			
		

Commands
---------
biadmin user can manually start SPSS Analytics Server with following command

/etc/init.d/spss_analytics start 


biadmin user can manually stop SPSS Analytics Server with following command

/etc/init.d/spss_analytics stop 

		
-  On target node, execute following command to verify installation

	Command : `ps -aef |grep -i aeserver` 
	
	It should give output as

		biadmin    24140       1  1 02:29 ?        00:00:03 java -Xms128m -Xmx256m -server -cp /opt/IBM/SPSS/AnalyticsServer/1.0.1/bin/../ae_wlpserver/usr/servers/aeserver/apps/AE_BOOT.war/WEB-INF/lib/derbynet.jar:/opt/IBM/SPSS/AnalyticsServer/1.0.1/bin/../ae_wlpserver/usr/servers/aeserver/apps/AE_BOOT.war/WEB-INF/lib/derbytools.jar: org.apache.derby.drda.NetworkServerControl start
		biadmin    24191       1  9 02:29 ?        00:00:20 /opt/IBM/SPSS/AnalyticsServer/1.0.1/jre/bin/java -XX:MaxPermSize=256m -Xms512M -Xmx2048M -Dconfig.folder.path=/opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/usr/servers/aeserver/configuration -Dlog4j.configuration=file:////opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/usr/servers/aeserver/configuration/log4j.xml -Dderby.system.home=/opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/usr/servers/aeserver -Dclient.encoding.override=UTF-8 -javaagent:/opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/lib/bootstrap-agent.jar -jar /opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/lib/ws-launch.jar aeserver --clean
		biadmin    24279   24191  2 02:29 ?        00:00:04 /opt/IBM/SPSS/AnalyticsServer/1.0.1/jre/bin/java -Dlogger.id=localhost-1200/ -Dconfig.profile= -Dconfig.folder.path=/opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/usr/servers/aeserver/configuration -Dlog4j.configuration=file:////opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/usr/servers/aeserver/configuration/log4j.xml -Djava.library.path=/opt/IBM/SPSS/AnalyticsServer/1.0.1/jre/lib/amd64/default:/opt/IBM/SPSS/AnalyticsServer/1.0.1/jre/lib/amd64:/opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/usr/servers/aeserver/configuration/lib_32:/opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/usr/servers/aeserver/configuration/lib_64::/usr/lib -Xms256m -Xmx2048m -server -Das.child.proc.group=1 -cp apps/AE_BOOT.war/WEB-INF/lib/* com.spss.executionprocess.Main -maxconnections 10 -port 1200
		biadmin    24286   24191  2 02:29 ?        00:00:03 /opt/IBM/SPSS/AnalyticsServer/1.0.1/jre/bin/java -Dlogger.id=localhost-1201/ -Dconfig.profile= -Dconfig.folder.path=/opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/usr/servers/aeserver/configuration -Dlog4j.configuration=file:////opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/usr/servers/aeserver/configuration/log4j.xml -Djava.library.path=/opt/IBM/SPSS/AnalyticsServer/1.0.1/jre/lib/amd64/default:/opt/IBM/SPSS/AnalyticsServer/1.0.1/jre/lib/amd64:/opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/usr/servers/aeserver/configuration/lib_32:/opt/IBM/SPSS/AnalyticsServer/1.0.1/ae_wlpserver/usr/servers/aeserver/configuration/lib_64::/usr/lib -Xms256m -Xmx2048m -server -Das.child.proc.group=1 -cp apps/AE_BOOT.war/WEB-INF/lib/* com.spss.executionprocess.Main -maxconnections 10 -port 1201



Authors
-----------------
- Author: Aniruddha Navare (<annavare@in.ibm.com>)
