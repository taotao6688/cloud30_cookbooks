
# DESCRIPTION:

Installs and configures tomcat 7.0.52 only.


# REQUIREMENTS:

This cookbook depends on these external cookbooks

- java
- openssl

## Platform:

- Red Hat Enterprise Linux 6.x for 64-bit x64 

### Installable 
- Please make sure, `apache-tomcat-X.X.XX.tar.gz` are available for installation over HTTP URL as `http://0.0.0.0/`


# USAGE:

We need to create role specific to tomcat  before starting cookbook execution.

Create role with command : knife role create role_tomcat

-Please make sure, role defination looks like

- Create role as 'role_tomcat' 
 {
	"name": "role_tomcat",
  	"description": "Cookbook to install Tomcat",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": [
		"recipe[java::oracle]",
		"recipe[tomcat-master]"
  	],

  	 "env_run_lists": {
  	}
 }

 -  Once role is created, bootstrap as
 
	knife bootstrap <IP> -x root -P <password> -r role[role_tomcat] -d <distribution>  -j '{"source_path":"URL","base_version":"base_version","full_version":"full_version"}'
	
	where
		IP : IP address of node where Tomcat need to install
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : HTTP path mentioned in `Installable` section
		base_version : Base version number of Tomcat version.
		full_version : Full version number of Tomcat versipon.
	

- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.

		IP : 172.16.1.152 (Target Node for Tomcat installation)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		URL : http://172.16.1.153 (So if you hit "http://172.16.1.153/apache-tomcat-7.0.52.tar.gz" from browser, you should able to download this file if you are installing Tomcat 7.0.52)
		base_version : 7
		full_version : 7.0.52
		
		So user can run command like
		
		knife bootstrap 172.16.1.152  -x root -P test4pass -r role[role_tomcat] -j '{"source_path":"http://172.16.1.153","base_version":"7","full_version":"7.0.52"}' 


## Verification
----------------
 On target node, execute following command to verify installation

	Command : `ps -aef |grep -i tomcat` 
	
	It should give output as 
			
		root      305088       1  6 23:23 pts/0    00:00:03 /usr/lib/jvm/java/bin/java -Djava.util.logging.config.file=/etc/tomcat7/conf/logging.properties -Djava.util.logging.manager=org.apache.juli.ClassLoaderLogManager -Djava.endorsed.dirs=/etc/tomcat7/endorsed -classpath /etc/tomcat7/bin/bootstrap.jar:/etc/tomcat7/bin/tomcat-juli.jar -Dcatalina.base=/etc/tomcat7 -Dcatalina.home=/etc/tomcat7 -Djava.io.tmpdir=/etc/tomcat7/temp org.apache.catalina.startup.Bootstrap start

## Start / Stop of Tomcat
--------------------------
User can use following commands to do start / stop. 

Start : /etc/init.d/tomcatX start
Stop : /etc/init.d/tomcatX stop

where "tomcatX" file name will be created as user has passed the base version. 
			
			
# LICENSE and AUTHOR:

- Author: Aniruddha Navare (<annavare@in.ibm.com>)

