Biginsights2.1.2 Cookbook
=========================
Installs and configure BigInsights 2.1.2

Please note that, cookbook will install BigInsights with default password given below. Users are requested to change later for security purpose

biadmin / biadmin123
db2inst1 / db123

Requirements
------------
### Platform
- Red Hat Enterprise Linux 6.5 for 64-bit x64 (kernel 2.6.32-431)


### Installable 
- Please make sure, `IS_BIGINSIGHTS_EE_V2.1.2_LNX64.tar.gz` is available for installation over HTTP URL as `http://0.0.0.0/`


### Package Requirment
- Please make sure, all the below mentioned libraries are available at some RPM repository.
	- expect
	- ntp	

- To confirm whether RPM are part of RPM repository, run command "yum list | grep -i expect" as root, you are able to list rpm for expect.	Similar check should be done for ntp package.


### resolve.conf setting
- Please make sure, you have proper setting done for /etc/resolve.conf for nameserver before proceeding further. In case of wrong setting, it will result in failure in ntpstart time synchronization.


### ntpstat time synchronization
- Please make sure, ntpstat program on targeted node, is synchronized with a time server. Do not proceed in case there is issue.
- In case any issue, please restart ntpd server as "service ntpd restart" following by "ntpdate". It should show correct time


### Default Password for Root
- For installation purpose, please make sure, root password is "test4pass". You can change it later. Cookbook will fail if password is different.


### Entry in /etc/hosts
- Please add target node entry in /etc/hosts 


### SSH Authentication
- Please make sure you are able to login to target node with command :  ssh root@<target_node_name> and vice versa. It is necessary that both nodes (Chef Server node & target node) must be able to login with SSH without password. Do not proceed if this is not working. 

- User can use following steps to configure SSH authentication on chef server & target node
	- As root, run command : ssh-keygen
	- Proceed with steps
	- As root, run commmand : ssh-copy-id -i root@ip_address where ip_address is node where you want to login without password
	- Verify ssh root@<target_node_name>



### Space Required
- For BigIngishts installation, min 25GB is required.


### Make sure, following users doesn't exists on target node
- User List : biadmin hdfs mapred zookeeper hbase hive oozie monitoring httpfs console alert orchestrator db2inst1 hadoop appadmin1 appadmin2 sysadmin1 sysadmin2 dataadmin1 dataadmin2 user1 user2 user3
- In case any user if found, make sure you delete user will command " userdel -r <username>" as root. 


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

 -  Once role is created, bootstrap the node as

	knife bootstrap <IP> -x root -P <password> -r role[role_biginsights] -d <distribution>  -j '{"biginsights": {"source_path":"URL","rpm_path":"RPM_URL","sso_domain":"SSO_DOMAIN","node_name":"NODE_NAME"}}'
	
	where
		IP : IP address of node where BigInsights need to install
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : HTTP path mentioned in `Installable` section
		RPM_URL : RPM Path where you will find the required libraries mentioned above
		SSO_DOMAIN : SSO Domain name 
		NODE_NAME : Fully qualified name of target name. Don't provide any IP address. 
		
- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.

		IP : 172.16.1.184 (Target Node for BigInsights installation)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		source_path : http://172.16.1.153 (So if you hit "http://172.16.1.153/IS_BIGINSIGHTS_EE_V2.1.2_LNX64.tar.gz" from browser, you should able to download this file)
		rpm_path : http://172.16.0.10:8080/redhat/rhel/6Server/x86_64/ (Where you will find the required libraries mentioned above)
		sso_domain : domain1
		node_name : fat-euphrates (Please execute command "hostname" to figure out fully qualified name)
		
		So user can run command like
		
		knife bootstrap 172.16.1.184 -x root -P test4pass -r role[role_biginsights] -d rhel -j '{"biginsights": {"source_path":"http://172.16.1.153","rpm_path":"http://172.16.0.10:8080/redhat/rhel/6Server/x86_64/","sso_domain":"domain1","node_name":"fat-euphrates"}}'	

		
		
Note
-----

This cookbook takes around ~1 hr depending upon machine configuration. User can go to target node and navigate to chef cache directory (Typically /var/chef/cache). Tail to log files as shown below to check process

<chef_cache_dir>/biginsights-enterprise-linux64_b20140318_1321/silent_install/silent-install_XXXXXXXX.log


License and Authors
-------------------
Author: Aniruddha Navare (<annavare@in.ibm.com>)
