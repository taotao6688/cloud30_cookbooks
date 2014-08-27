# Description

Install/Configure DB2

## Recipes

* db2::install  Install DB2

* db2::restart  Restart DB2 instance

* db2::database Create a DB2 database

* db2:user Create a DB2 database user

* db2:primary Setup DB2 HA primary

* db2:standby Setup DB2 HA standby

## Usage

### Install db2

* Simple way:

```
db2 "install db2" do
    action :install
end

```

* Full parameters

```
db2 "install db2" do
    version "10.5"
    prod    "DB2_SERVER_EDITION"
    port 50000
    fcm_port 60000
    max_logical_nodes 4
    instance_name "db2inst1"
    instance_type "ese"
    instance_home_dir "/home/db2inst1"
    instance_username "db2inst1"
    instance_password "passw0rd"
    fenced_username "db2fenc1"
    fenced_password "passw0rd"
    das_username "db2das1"
    req_packages ["libaio", "dapl", "sg3_utils"]
    action :install
end
```

### Create DB2 database

```
db2_database "create database #{node['db2']['db_name']}" do
    db_name node['db2']['db_name']
    action :create
end
```

### Create a database user

By default, this recipe will not create shema and the privileges is DBADM.

db2_user "create database user" do
    db_user     node['db2']['db_user']
    db_pass     node['db2']['db_pass']
    db_name     node['db2']['db_name']
    # privileges  'CONNECT,DATAACCESS'
    action :create
end

### Setup a database HA Primary node

```
db2_primary "setup DB2 primary" do
    db_name      node['db2']['db_name']
    primary_host node['db2']['primary_host']
    primary_port node['db2']['primary_port']
    standby_host node['db2']['standby_host']
    standby_port node['db2']['standby_port']
    action :setup
end
```

The Primary node VIP transfer section can be found in `db2::primary` recipe.

### Setup a database HA Standby node

```
db2_standby "setup DB2 standby" do
    db_name      node['db2']['db_name']
    primary_host node['db2']['primary_host']
    primary_port node['db2']['primary_port']
    standby_host node['db2']['standby_host']
    standby_port node['db2']['standby_port']
    action :setup
end
```

The Standby node VIP transfer section can be found in `db2::standby` recipe.

###### 
Changes done on Db2 cookbook: 
1. Version is 0.1.2
2. Made changes only on attribute file and providers/default file which is responsible for Db2 server installation.
3. Cookbook is created in such a way that it will install the db2 10.5 into RHEL as well as UBUNTU
4. Added ftpserver path to download the installer of db2.
5. Added library package for RHEL and UBUNTU to get db2 installation successful on RHEL and UBUNTU.
6. Added code for location of db2 service according to platform.
