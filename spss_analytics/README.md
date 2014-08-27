SPSS Analytics Server Cookbook
=============================
Installs and configures SPSS  Analytics Server v1.0.1.0.112


Requirements
------------
### Platform
- Red Hat Enterprise Linux 6.5 for 64-bit x64 (kernel 2.6.32-431)


### Installable 
- Please make sure, `anl_svr_1.0.1.0_l86_en_.tar.gz` is available for installation over HTTP URL as `http://0.0.0.0/`


### Dependencies


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

	knife bootstrap <IP> -x root -P <password> -r role[role_spss_analytics] -d <distribution>  -j '{"source_path":"URL","dirpath":"spss_analytics_server_home"}'
	
	where
		IP : IP address of node where SPSS analytics Server need to install
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : HTTP path mentioned in `Installable` section
		spss_analytics_server_home : SPSS Analytics Server Home Directory.

Commands
---------
User can manually start SPSS Analytics Server with following command

/etc/init.d/spss_analytics start 


User can manually stop SPSS Analytics Server with following command

/etc/init.d/spss_analytics stop 

		
-  On target node, execute following command to verify installation

	Command : `ps -aef |grep -i model` 
	
	It should give output as

		root      7229     1  0 15:55 ?        00:00:03 java -Xms128m -Xmx256m -server -cp /usr/IBM/SPSS/ModelerServer/bin/../ae_wlpserver/usr/servers/aeserver/apps/AE_BOOT.war/WEB-INF/lib/derbynet.jar:/usr/IBM/SPSS/ModelerServer/bin/../ae_wlpserver/usr/servers/aeserver/apps/AE_BOOT.war/WEB-INF/lib/derbytools.jar: org.apache.derby.drda.NetworkServerControl start
		root      7657     1  0 16:07 pts/0    00:00:23 /usr/IBM/SPSS/ModelerServer/jre/bin/java -XX:MaxPermSize=256m -Xms512M -Xmx2048M -Dconfig.folder.path=/usr/IBM/SPSS/ModelerServer/ae_wlpserver/usr/servers/aeserver/configuration -Dlog4j.configuration=file:////usr/IBM/SPSS/ModelerServer/ae_wlpserver/usr/servers/aeserver/configuration/log4j.xml -Dderby.system.home=/usr/IBM/SPSS/ModelerServer/ae_wlpserver/usr/servers/aeserver -Dclient.encoding.override=UTF-8 -javaagent:/usr/IBM/SPSS/ModelerServer/ae_wlpserver/lib/bootstrap-agent.jar -jar /usr/IBM/SPSS/ModelerServer/ae_wlpserver/lib/ws-launch.jar aeserver --clean
		root      7733  7657  0 16:07 pts/0    00:00:03 /usr/IBM/SPSS/ModelerServer/jre/bin/java -Dlogger.id=localhost-1200/ -Dconfig.profile= -Dconfig.folder.path=/usr/IBM/SPSS/ModelerServer/ae_wlpserver/usr/servers/aeserver/configuration -Dlog4j.configuration=file:////usr/IBM/SPSS/ModelerServer/ae_wlpserver/usr/servers/aeserver/configuration/log4j.xml -Djava.library.path=/usr/IBM/SPSS/ModelerServer/jre/lib/amd64/default:/usr/IBM/SPSS/ModelerServer/jre/lib/amd64:/usr/IBM/SPSS/ModelerServer/ae_wlpserver/usr/servers/aeserver/configuration/lib_32:/usr/IBM/SPSS/ModelerServer/ae_wlpserver/usr/servers/aeserver/configuration/lib_64::/usr/lib -Xms256m -Xmx2048m -server -Das.child.proc.group=1 -cp apps/AE_BOOT.war/WEB-INF/lib/* com.spss.executionprocess.Main -maxconnections 10 -port 1200
		root      7740  7657  0 16:07 pts/0    00:00:03 /usr/IBM/SPSS/ModelerServer/jre/bin/java -Dlogger.id=localhost-1201/ -Dconfig.profile= -Dconfig.folder.path=/usr/IBM/SPSS/ModelerServer/ae_wlpserver/usr/servers/aeserver/configuration -Dlog4j.configuration=file:////usr/IBM/SPSS/ModelerServer/ae_wlpserver/usr/servers/aeserver/configuration/log4j.xml -Djava.library.path=/usr/IBM/SPSS/ModelerServer/jre/lib/amd64/default:/usr/IBM/SPSS/ModelerServer/jre/lib/amd64:/usr/IBM/SPSS/ModelerServer/ae_wlpserver/usr/servers/aeserver/configuration/lib_32:/usr/IBM/SPSS/ModelerServer/ae_wlpserver/usr/servers/aeserver/configuration/lib_64::/usr/lib -Xms256m -Xmx2048m -server -Das.child.proc.group=1 -cp apps/AE_BOOT.war/WEB-INF/lib/* com.spss.executionprocess.Main -maxconnections 10 -port 1201
		
	

Authors
-----------------
- Author: Aniruddha Navare (<annavare@in.ibm.com>)
