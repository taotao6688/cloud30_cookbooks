SPSS Modeler Server Cookbook
=============================
Installs and configures SPSS Modeler Server v16.0 


Requirements
------------
### Platform
- Red Hat Enterprise Linux 6.5 for 64-bit x64 (kernel 2.6.32-431)


### Installable 
- Please make sure, `spss_mod_svr_16.0_linux_ml.bin` is available for installation over HTTP URL as `http://0.0.0.0/`


### Dependencies

The following additional packages are needed. Please make sure, you install these
- The zlib package (version zlib-1.2.3-25.el6.x86_64)
- The pam package (version pam-1.1.1-4.el6.x86_64)
- The glibc package (version glibc-2.12-1.7.el6.x86_64)
- The libstdc++ package (version libstdc++-4.4.4-13.el6.x86_64)
- The libgcc package (version libgcc-4.4.4-13.el6.x86_64)
- The audit-libs package (version audit-libs-2.0.4-1.el6.x86_64)
- The nss-softokn-freebl package (version nss-softokn-freebl-3.12.7-1.1.el6.x86_64)



Usage
-----
You need to create role specific to SPSS Modeler Server before starting cookbook execution.

Create role with command :  knife role create role_spss_modeler_16

Please make sure, role definition looks like

 {
	"name": "role_spss_modeler_16",
  	"description": "SPSS Modeler Server Cookbook ",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": ["recipe[spss_modeler_16]"
  	],

  	 "env_run_lists": {
  	}
 }

	 
-  Once role is created, bootstrap the node as

	knife bootstrap <IP> -x root -P <password> -r role[role_spss_modeler_16] -d <distribution>  -j '{"spss_modeler": {"source_path":"URL","dirpath":"spss_modeler_server_home"}}'
	
	where
		IP : IP address of node where SPSS Modeler Server need to install
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : HTTP path mentioned in `Installable` section
		spss_modeler_server_home : SPSS Modeler Server Home Directory
		
- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.

		IP : 172.16.1.152 (Target Node for SPSS Modeler Server installation)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		source_path : http://172.16.1.153 (So if you hit "http://172.16.1.153/spss_mod_svr_16.0_linux_ml.bin" from browser, you should able to download this file)
		dirpath : /usr/IBM/SPSS/ModelerServer/16.0
		
		So user can run command like
		
		knife bootstrap 172.16.1.152 -x root -P test4pass -r role[role_spss_modeler_16] -d rhel -j '{"spss_modeler": {"source_path":"http://172.16.1.153","dirpath":"/usr/IBM/SPSS/ModelerServer/16.0"}}'		
		
		
-  On target node, execute following command to verify installation

	Command : `ps -aef |grep -i model` 
	
	It should give output as

		root     18883     1  0 20:34 ?        00:00:00 /usr/IBM/SPSS/ModelerServer/16.0/modelersrv_16_0 -server
		
		
Commands
---------------
User can manually start SPSS Modeler Server with following command

/etc/init.d/spss_modeler start 


User can manually stop SPSS Modeler Server with following command

/etc/init.d/spss_modeler stop 


Authors
-----------------
- Author: Aniruddha Navare (<annavare@in.ibm.com>)
