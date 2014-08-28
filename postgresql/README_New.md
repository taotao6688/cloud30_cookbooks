postgresql Cookbook
=========================
Installs and configure postgresql server along with postgresql libraries on RHEL 64 bit platform


Requirements
------------
### Platform
- Red Hat Enterprise Linux 6.x for 64-bit x64 (kernel 2.6.XX-XXX)


### Installable 

- Required RPMs
	postgresql93-libs-9.3.1-1PGDG.rhel6.x86_64.rpm
	postgresql93-9.3.1-1PGDG.rhel6.x86_64.rpm
	postgresql93-server-9.3.1-1PGDG.rhel6.x86_64.rpm

- Please make sure, all postgresql related RPM files (mentioned below) are available at RPM repository.

- As root, you are able to list above RPMs if you run command "yum list | grep -i postgresql93". In case of any failure, please clear your yum cache and recreate it.

### Users
- Please make sure, user "postgres" is not present on target node. In case user is present, please remove user with "userdel -r postgres" command


### Directories
- Please make sure, "/var/lib/pgsql" directory doesn't exist. 

Usage
-----
#### postgresql::server_redhat

You need to create role specific to postgresql before starting cookbook execution.

Create role with command :  knife role create role_postgresql

Please make sure, role definition looks like

 {
	"name": "role_postgresql",
  	"description": "postgresql Cookbook",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": ["recipe[postgresql::server_redhat]"
  	],

  	 "env_run_lists": {
  	}
 }

 -  Once role is created, bootstrap the node as

	knife bootstrap <IP> -x root -P <password> -r role[role_postgresql] -d <distribution>  -j '{"postgresql": {"source_path":"URL"}}'
	
	where
		IP : IP address of node where postgresql need to install
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : RPM Repository path where RPM files (mentioned above) can be found.

		
- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.

		IP : 172.16.1.152 (Target Node for postgresql installation)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		URL : http://172.16.0.10:8080/redhat/rhel/6Server/PSL/
		
		So user can run command like
		
		knife bootstrap 172.16.1.154 -x root -P test4pass -r role[role_postgresql] -d rhel -j '{"postgresql": {"source_path":"http://172.16.0.10:8080/redhat/rhel/6Server/PSL/"}}'
		
		
## Verification
----------------
 On target node, execute following command to verify installation

	Command : `ps -aef |grep -i pgsql` 
	
	It should give output as 
			
	postgres  302972       1  0 22:42 ?        00:00:00 /usr/pgsql-9.3/bin/postmaster -p 5432 -D /var/lib/pgsql/9.3/data
	

License and Authors
-------------------
Author: Aniruddha Navare (<annavare@in.ibm.com>)
