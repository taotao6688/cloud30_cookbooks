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
		dirpath : usr/IBM/SPSS/AnalyticsServer

		
		So user can run command like
		
		knife bootstrap 172.16.1.152 -x root -P test4pass -r role[role_spss_analytics] -d rhel -j '{"spss_analytics": {"source_path":"http://172.16.1.153","dirpath":"/usr/IBM/SPSS/AnalyticsServer"}}'		
			
		

Commands
---------
User can manually start SPSS Analytics Server with following command

/etc/init.d/spss_analytics start 


User can manually stop SPSS Analytics Server with following command

/etc/init.d/spss_analytics stop 

		
-  On target node, execute following command to verify installation

	Command : `ps -aef |grep -i model` 
	
	It should give output as

		root      751321       1  0 19:48 ?        00:00:02 java -Xms128m -Xmx256m -server -cp /usr/IBM/SPSS/AnalyticsServer/bin/../ae_wlpserver/usr/servers/aeserver/apps/AE_BOOT.war/WEB-INF/lib/derbynet.jar:/usr/IBM/SPSS/AnalyticsServer/bin/../ae_wlpserver/usr/servers/aeserver/apps/AE_BOOT.war/WEB-INF/lib/derbytools.jar: org.apache.derby.drda.NetworkServerControl start

		
	

Authors
-----------------
- Author: Aniruddha Navare (<annavare@in.ibm.com>)
