WLP Cookbook
=========================
# Description

The wlp cookbook installs and configures the WebSphere Application Server Liberty Profile.

## Basic configuration

The wlp cookbook can install Liberty profile from jar archive files or a zip file. The installation method is configured via the `node[:wlp][:install_method]` attribute.
Here we are  using the jar archive file "wlp-developers-runtime-8.5.5.3.jar"

### jar installation

- Please make sure, 'wlp-developers-runtime-8.5.5.3.jar' is available for installation over HTTP URL as `http://0.0.0.0/`
 
# Requirements

- please make sure,Java 1.6 onwards is installed on the machine .
 
 ## Platform
- Red Hat Enterprise Linux 6.5 for 64-bit x64 (kernel 2.6.32-431)

# Attributes

* `node[:wlp][:base_dir]` - Base installation directory. Defaults to `"/opt/was/liberty"`.
* `node[:wlp][:install_method]` - Installation method. Set it to 'archive' or 'zip'. Defaults to `"archive"`.
* 'node[:wlp][:archive][:base_url] = "#{node[wlp_archive]['sourcepath']}"
 		here "node[wlp_archive]['sourcepath']" is the Base URL location for downloading the runtimeLiberty profile archives. 

# Recipes

* [wlp::default] - Installs WebSphere Application Server Liberty Profile.
* [wlp::serverconfig] - Creates a Liberty profile server instance .
	 
	
Usage
-----
You need to create role specific to WLP before starting cookbook execution.

Create role with command :  knife role create role_wlp

Please make sure, role definition looks like

 {
	"name": "role_wlp",
  	"description": "WebSphere Application Server Liberty Profile Cookbook",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": ["recipe[wlp::default]","recipe[wlp::serverconfig]"
  	],

  	 "env_run_lists": {
  	}
 }
 
 -  Once role is created, bootstrap the node as

	knife bootstrap <IP> -x root -P <password> -r role[role_wlp] -d <distribution>  -j '{"wlp_archive": {"sourcepath":"URL"}}'		
	
	where
		IP : IP address of node where WebSphere Application Server Liberty Profile server need to install
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : HTTP path mentioned in `Installable` section 
		
		
- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.

		IP : 172.16.1.152 (Target Node for WebSphere Application Server Liberty Profile server installation)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		source_path : http://172.16.1.153 (So if you hit "http://172.16.1.153/wlp-developers-runtime-8.5.5.3.jar" from browser, you should able to download this file)
		
		So user can run command like
		
		knife bootstrap 172.16.1.152 -x root -P test4pass -r role[role_wlp] -d rhel -j '{"wlp_archive": {"sourcepath":"http://172.16.1.153"}}'
		
		These will create Liberty profile instance named 'defaultServer'.
		Usually ,we create our own server which can be done as mentioend below in Commands Section
		
Note
------
Please note, user can other provided attributes (as mentioned above in 'Attribute' section) during bootstrap in case want to change basic setting. It is recommended not to change any default settings.
		

Commands
---------

Switch to /opt/was/liberty/wlp/bin

Create server by running the command
	
	./server create server1
	
output:
		Server server1 created.

Now start ther server created above 

	./server start server1
	
output : 
		Starting server server1.
		Server server1 started with process ID XXXX.


		
-  On target node, execute following command to verify installation

	Command : `ps -aef|grep -i server1` 
	
	It should give output as

		root     27169     1  0 12:00 pts/0    00:00:07 java -XX:MaxPermSize=256m -javaagent:/opt/was/liberty/wlp/bin/tools/ws-javaagent.jar -jar /opt/was/liberty/wlp/bin/tools/ws-server.jar server1
		root     27326 26746  0 12:51 pts/0    00:00:00 grep -i server1



Authors
-----------------
- Author: Gaurav Harsola (<gharsola@in.ibm.com>)