# Description

Install/Configure DB2 10.5


## Platform:

- Red Hat Enterprise Linux 6.x for 64-bit x64 


### Installable 
- Please make sure, `DB2_Svr_V10.5_Linux_x86-64.tar.gz` are available for installation over HTTP URL as `http://0.0.0.0/`

- Required libraries
	Please make sure, all the below mentioned libraries are available at some RPM repository.
	libaio
	dapl
	sg3_utils
	libibcm
	ibsim
	ibutils
	libcxgb3
	libipathverbs
	libibmad
	libibumad
	libipathverbs
	libmthca
	libnes
	rdma
	
- To confirm whether RPM are part of RPM repository, run command "yum list | grep -i postgresql" as root, you are able to list rpm name mentioned above.



## Usage

We need to create role specific to db2 before starting cookbook execution.

Create role with command : knife role create role_db2

-Please make sure, role defination looks like

- Create role as 'role_db2' 
 {
	"name": "role_db2",
  	"description": "Cookbook to install db2 ",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": ["recipe[db2::install]" 
  	],

  	 "env_run_lists": {
  	}
 }

-  Once role is created, bootstrap as

	knife bootstrap <IP Address> -x root –P <password> -r role[role_db2] –d <distribution> -j '{"source_path":"URL","repo_path":"REPO_URL"}'
	
	where
		IP Address : IP address of node, Where we want to install db2.
		Password : Root password of IP address of node
		Distribution : Target distribution available
		URL : HTTP path mentioned in `Installable` section
		REPO_URL : Repository path where required libraries are available. 
		
- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.
		
		IP : 172.16.1.152 (Target Node for DB2 installation)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		URL : http://172.16.1.153 (So if you hit "http://172.16.1.153/DB2_Svr_V10.5_Linux_x86-64.tar.gz" from browser, you should able to download this file)
		REPO_URL : http://172.16.0.10:8080/redhat/rhel/6Server/x86_64 (All RPMs are available at this repository)
		
		So user can run command like
		
		knife bootstrap 172.16.1.152 -x root -P test4pass -r role[role_db2] -d rhel -j '{"source_path":"http://172.16.1.153","repo_path":"http://172.16.0.10:8080/redhat/rhel/6Server/x86_64"}'			
		
## Verification
----------------
On target node, execute following command to verify installation

	Command : `ps -aef |grep -i db2` 
	
	It should give output as 
			
		db2das1   387399       1  0 18:20 ?        00:00:00 /home/db2das1/das/adm/db2dasrrm
		root      396303       1  0 18:20 ?        00:00:00 db2wdog 0 [db2inst1]                                        
		db2inst1  396305  396303  0 18:20 ?        00:00:00 db2sysc 0                                      
		root      396306  396305  0 18:20 ?        00:00:00 db2ckpwd 0                                                  
		root      396307  396305  0 18:20 ?        00:00:00 db2ckpwd 0                                                  
		root      396308  396305  0 18:20 ?        00:00:00 db2ckpwd 0                                                  
		db2inst1  396315  396303  0 18:20 ?        00:00:00 db2vend (PD Vendor Process - 1) 0                                                                                            
		db2inst1  396326  396303  0 18:20 ?        00:00:00 db2acd 0 ,0,0,0,1,0,0,0,0000,1,0,9959d0,14,1e014,2,0,1,11fc0,0x210000000,0x210000000,1600000,38003,2,12801c
		root      396843    1443  0 18:23 pts/0    00:00:00 grep -i db2



Authors
-----------------
- Author: Aniruddha Navare (<annavare@in.ibm.com>)


