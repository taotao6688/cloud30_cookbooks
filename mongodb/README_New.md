
# DESCRIPTION:
------------
Installs and configures MongoDB, supporting:

* Single MongoDB


Requirements
------------
### Platform
- Red Hat Enterprise Linux 6.x for 64-bit x64 (kernel 2.6.XX-XXX)

### Installable 
- Please make sure, all MongoDB related RPM files (mentioned below) are available at certain RPM repository.

- As root, you are able to list them if run command "yum list | grep -i mongodb". In case of any failure, please clear your yum cache and recreate it.

- Required RPMs
	mongodb-org-server-2.6.0-1.x86_64.rpm
	mongodb-org-mongos-2.6.0-1.x86_64.rpm
	mongodb-org-shell-2.6.0-1.x86_64.rpm
	mongodb-org-tools-2.6.0-1.x86_64.rpm
	mongodb-org-2.6.0-1.x86_64.rpm

	
# USAGE:
------------
We need to create role specific to mongodb  before starting cookbook execution.

Create role with command : knife role create role_mongodb

-Please make sure, role defination looks like

- Create role as 'role_mongodb' 
 {
	"name": "role_mongodb",
  	"description": "Cookbook to install mongodb",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": ["recipe[mongodb]" 
  	],

  	 "env_run_lists": {
  	}
 }

 -  Once role is created, bootstrap as
 
	knife bootstrap <IP> -x root -P <password> -r role[role_mongodb] -d <distribution>  -j '{"source_path":"URL","mongodb_port":"27017","replicasetname":"rs1"}'
	
	where
		IP : IP address of node where MongoDB need to install
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : Repository Path where MongoDB RPMs are found
		mongodb_port : Port for MongoDB
		replicasetname : Name for replicaset 		

- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.

		IP : 172.16.1.152 (Target Node for MongoDB installation)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		URL : http://172.16.0.10:8080/redhat/rhel/6Server/PSL/
		mongodb_port: 27017
		replicasetname : rs1
		
		So user can run command like
		
			knife bootstrap 172.16.1.152  -x root -P test4pass -r role[role_mongodb] -d rhel -j '{"source_path":"http://172.16.0.10:8080/redhat/rhel/6Server/PSL/","mongodb_port":"27017","replicasetname":"rs1"}' 


## Verification
----------------
 On target node, execute following command to verify installation

	Command : `ps -aef |grep -i mongod` 
	
	It should give output as 
			
		mongod      1307       1  0 Aug14 ?        00:48:04 /usr/bin/mongod --config /etc/mongodb.conf
			
			
# LICENSE and AUTHOR:

- Author: Aniruddha Navare (<annavare@in.ibm.com>)

