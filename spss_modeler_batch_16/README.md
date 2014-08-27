SPSS Modeler Batch Server Cookbook
=============================
Installs SPSS Modeler Batch Server v16.0 


### Platform
- Red Hat Enterprise Linux 6.5 for 64-bit x64 (kernel 2.6.32-431)


### Installable 
- Please make sure, `spss_mod_Btch_16.0_linux_ml.bin` is available for installation over HTTP URL as `http://0.0.0.0/`


Usage
-----
You need to create role specific to SPSS Modeler Batch Server before starting cookbook execution.

Create role with command :  knife role create role_spss_batch_16

Please make sure, role definition looks like

 {
	"name": "role_spss_batch_16",
  	"description": "SPSS Modeler Batch Server Cookbook ",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": ["recipe[spss_modeler_batch_16]"
  	],

  	 "env_run_lists": {
  	}
 }


	 
-  Once role is created, bootstrap the node as

	knife bootstrap <IP> -x root -P <password> -r role[role_spss_batch_16] -d <distribution>  -j '{"source_path":"URL","dirpath":"spss_batch_server_home"}'
	
	where
		IP : IP address of node where SPSS Modeler Batch Server need to install
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : HTTP path mentioned in `Installable` section
		spss_batch_server_home : SPSS Modeler Batch Server Home Directory
		
		
		
- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.

		IP : 172.16.1.152 (Target Node for SPSS Modeler Batch Server installation)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		URL : http://172.16.1.153 (So if you hit "http://172.16.1.153/spss_mod_Btch_16.0_linux_ml.bin" from browser, you should able to download this file)
		spss_batch_server_home : /usr/IBM/SPSS/ModelerBatchServer
		
		So user can run command like
		
		knife bootstrap 172.16.1.152 -x root -P test4pass -r role[role_spss_batch_16] -d rhel -j '{"source_path":"http://172.16.1.153","dirpath":"/usr/IBM/SPSS/ModelerBatchServer"}'		
		
	
Authors
-----------------
- Author: Aniruddha Navare (<annavare@in.ibm.com>)
