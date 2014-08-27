# Description
--------------
Configure Mongodb with High Availability


## Recipes
-----------
* mongodb-HA::default  Configure Replicaset (Primary, Secondary , Arbiter nodes with MongoDB Instances )
* mongodb-HA::addSecondary  Add more Secondary(s) in already confgiured replicaset.


### Dependencies
- Mongodb should be installed. 



## Usage
---------
We need to create role specific to mongodb high availablilty before starting cookbook execution.

Create role with command : knife role create role_mongodb_HA

-If,you want to have only one Primary ,one Secondary and one Arbiter to be in replicaset 

-Please make sure, role defination looks like

- Create role as 'role_mongodb_HA' 
 {
	"name": "role_mongodb_HA",
  	"description": "Cookbook to configure mongodb instance ",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": ["recipe[mongodb-HA]" 
  	],

  	 "env_run_lists": {
  	}
 }

	 
-  Once role is created, bootstrap as

	knife bootstrap <primary IP> -x root -P <password> -r role[role_mongodb_HA] -d <distribution>
        -j '{"primary":"<primaryIP>","secondary":"<SecondaryIPs separated by space>", "primary_port":"<PrimaryMongoPort>","secondary_port":"<SecondaryMongoPort>","arbiter":"<ArbiterIP>","arbiter_port":"<ArbiterMongoPort>","replicasetName":"<ReplicaName>"}'	
	where
		primary IP : IP address of node, which we want to act as Primary in replicaset.
		Password : Root password of IP address of node
		Distribution : Target distribution available
		secondary : IP address of node, which we want to act as Secondary in replicaset.
        primary_port : port of the primary machine where we want the mongodb to be run.By default 27017.
		secondary_port : port of the primary machine where we want the mongodb to be run.By default 27017.
		arbiter : IP address of node, which we want to act as Arbiter in replicaset.
		arbiter_port : port of the primary machine where we want the mongodb to be run.By default 27017.

		
- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.

		IP : 172.16.1.151 (Primary Node for MongoDB HA Configuration)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		primary : 172.16.1.151
		secondary: 172.16.1.152
		primary_port: 27017
		secondary_port: 27017
		arbiter: 172.16.1.153
		arbiter_port: 27017
		replicasetname : rs1
		
		So user can run command like
		
		knife bootstrap 172.16.1.151  -x root -P test4pass -r role[role_mongodb_HA] -d rhel -j '{"primary":"172.16.1.151","secondary":"172.16.1.152", "primary_port":"27017","secondary_port":"27017","arbiter":"172.16.1.153","arbiter_port":"27017","replicasetName":"rs1"}' 		

- If you want to add more secondary machine after configuration of MongoDB in HA mode (i.e. after you bootstrap node with MongoDB-HA cookbook), you need to create role as

-Create role with command : knife role create role_mongodb_HA_addSecondary

-Please make sure, role defination looks like

{
	"name": "role_mongodb_HA_addSecondary",
  	"description": "Cookbook to configure mongodb instance ",
  	"json_class": "Chef::Role",
  	"default_attributes": {
  	},
  	"override_attributes": {
  	},
  	"chef_type": "role",
  	"run_list": ["recipe[mongodb-HA::addSecondary]" 
  	],

  	 "env_run_lists": {
  	}
 }

-  Once role is created, always bootstrap the 'Secondary Node' as 

	knife bootstrap <primary IP> -x root -P <password> -r role[role_mongodb_addSecondary] -d <distribution> -j '{"secondaryIP":"<secondaryIP>"}'
	
	where
		primary IP : IP address of node, which act as primary in replicaset.
		Password : Root password of IP address of node
		Distribution : Target distribution available
		secondaryIP : IP address of node, which we want to add in our replicaset as secondary.
   
- Example : Please note that, this is just example. Please change following values are per your requirements. This values should not be used during cookbook execution.

		IP : 172.16.1.151 (Primary Node for MongoDB HA Configuration)
		Password : test4pass
		Distribution : rhel (Please check CHEF documentation for more help)
		secondaryIP: 172.16.1.154 (node which you want to add as secondary once HA configuration is present)
		
		So user can run command like
		
		knife bootstrap 172.16.1.151  -x root -P test4pass -r role[role_mongodb_addSecondary] -d rhel  -j '{"secondaryIP":"172.16.1.154"}' 	
		
		

## Verification
----------------

-  On each node of replicaset , execute following command to verify installation
	
		Command to run : mongo
		
		Command	Executed ON			Expected result
		----------------------------------------------------------
			       Primary			It should show prompt as <<replicasetName>:PRIMARY>
			       Secondary		It should show prompt as <<replicasetName>:SECONDARY>
			       Arbiter			It should show prompt as <<replicasetName>:ARBITER>
				   

-  Now following commands should be execute on "mongo" prompt
	
	Command			Executed ON		Expected result
	----------------------------------------------------------------
	rs.slaveOk()	Secondary		Nothing as result. But this command is needed before testing on secondary.
					Arbiter			Nothing as result. By running this command arbiter still don't replicate primary data

	rs.status()		Primary			It should show replica set configuration
					Secondary		It should show replica set configuration
					Arbiter			It should show replica set configuration


Authors
-----------------
- Author: Aniruddha Navare (<annavare@in.ibm.com>)



