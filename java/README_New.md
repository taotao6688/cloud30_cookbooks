Description
===========

This cookbook installs a Oracle JDK 1.7 update 51


Requirements
============

## Platform:

- Red Hat Enterprise Linux 6.x for 64-bit x64 


### Installable 
- Please make sure, `jdk-7u51-linux-x64.tar.gz` are available for installation over HTTP URL as `http://0.0.0.0/`


### 
Usage
=====


We need to create role specific to Java  before starting cookbook execution.

Create role with command : knife role create role_java

-Please make sure, role defination looks like

  Create role as 'role_java' 
 {
	"name": "role_mongodb",
  	"description": "Cookbook to install java ",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": ["recipe[java::oracle]" 
  	],

  	 "env_run_lists": {
  	}
 }
 
 
-  Once role is created, bootstrap as

	knife bootstrap <IP> -x root -P <password> -r role[role_java] -d <distribution>  -j '{"java": {"source_path":"URL"}}'		
	
	where
		IP : IP address of node, Where we want to install java.
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : HTTP path mentioned in `Installable` section
		
		
- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.

		IP : 172.16.1.152 (Target Node for java installation)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		URL : http://172.16.1.153 (So if you hit "http://172.16.1.153/jdk-7u51-linux-x64.tar.gz" from browser, you should able to download this file)
		
		So user can run command like
		
		knife bootstrap 172.16.1.152 -x root -P test4pass -r role[role_java] -d rhel -j '{"java": {"source_path":"http://172.16.1.153"}}'		

# LICENSE and AUTHOR:

- Author: Aniruddha Navare (<annavare@in.ibm.com>)



