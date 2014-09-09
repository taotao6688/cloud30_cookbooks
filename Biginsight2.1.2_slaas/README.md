Biginsights2.1.2 Cookbook
=========================
Installs and configure BigInsights 2.1.2
Version of the cookbook is 0.1.1 due to modifications.
Please note that, cookbook will install BigInsights with default password given below

biadmin / biadmin123
db2inst1 / db123

Requirements
------------
### Platform
- Red Hat Enterprise Linux 6.5 for 64-bit x64 (kernel 2.6.32-431)

### Installable 
- Please make sure, `IS_BIGINSIGHTS_EE_V2.1.2_LNX64.tar.gz` is available for installation over ARTIFACT SERVER `ftp://50.22.178.238/artifacts/chef_installable/bi`

### Package Requirment
- Please make sure, targeted node has following libraries available and installed successfully.
	- expect
	- ntp	
	
### Password
- For installation purpose, please make sure, root password is "test4pass". You can change it later. Cookbook will fail if password is different.

### Entry in /etc/hosts
- Please add target node entry in /etc/hosts 
- For SSH authentication, make sure you are able to login to target node with command :  ssh root@<target_node_name>. 

Attributes
----------
* `node['biginsights']['default_pkg']` - The Big Insights installation .TAR file name for version 2.1.2
* `node['biginsights']['default_dir']` - Default directory for chef cache where installation will start`.

Modifications on  0.1.0 version
-------------------------------
1. Added code to install the package a)expect b)ntp in recipes/default.rb
2. Commented the remote_file resource and added execute resource to download the installer from Artifact Server.
3. Added code in "bash resource" to extract the installer tar file and then removing installer from target node to free up space.

Usage
-----
#### Biginsights2.1.2::default

You need to create role specific to BigInsight before starting cookbook execution.

Create role with command :  knife role create role_biginsights

Please make sure, role definition looks like

 {
	"name": "role_biginsights",
  	"description": "BigInsight Cookbook",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": ["recipe[Biginsights2.1.2]"
  	],

  	 "env_run_lists": {
  	}
 }

 -  Once role is created, do these things.....

1. Create a json file in target node under /etc/chef for example bi.json
2. Content of bi.json file should be 
    {"run_list": [ "role[role_biginsights]" ],"sso_domain":"<domain>","node_name":"<hostname>"}
    Example :
	[root@swfbi99250 ~]# cat /etc/chef/bi.json
	{"run_list": [ "role[role_biginsights]" ],"sso_domain":"heaton.softlayer.com","node_name":"swfbi99250"}
3. Run : chef-client -j /etc/chef/bi.json
4. Above 1,2 and 3 steps are implemented in HEAT template for the deployment.




##	knife bootstrap <IP> -x root -P <password> -r role[role_biginsights] -d <distribution>  -j '{"source_path":"URL","sso_domain":"SSO_DOMAIN","node_name":"NODE_NAME"}'
	
	where
		IP : IP address of node where SPSS analytics Server need to install
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : HTTP path mentioned in `Installable` section
		SSO_DOMAIN : SSO Domain name 
		NODE_NAME : Fully qualified name of target name. Don't provide any IP address. 


License and Authors
-------------------
Author: Dheeraj Dubey (<dheerajd@us.ibm.com>)
