# Description

Install/Configure COGNOS BI Server 10.2.1

## Recipes

* cognos::install  Install Cognos BI Server Components

* cognos::httpd  Install HTTPD server on Cognos Server

* cognos::install_db2_client Install DB2 Client on Cognos server

* cognos::catalog_cognos_db Catalog Cognos database from DB2 server to Cognos server

## Usage

### Install Cognos BI Server components
```

* Full parameters

```
cognos "install cognos" do
  version             node['cognos']['version']
  agreement           node['cognos']['license']['agreement']
  install_dir         node['cognos']['install_dir']
  bi_server           node['cognos']['bi_server']
  backup              node['cognos']['backup']
  application_tier    node['cognos']['application_tier']
  gateway             node['cognos']['gateway']
  content_manager     node['cognos']['content_manager']
  content_database    node['cognos']['content_database']
  req_packages        node['cognos']['req_packages']
  action :install
end

```

### Install HTTPD server
```

```

### Install database client
```
cognos_install_db2_client "Installing DB2 client 10.5" do
        check_db2_client        node['cognos']['db2_client']['check_db2_client']
        file_path               node['cognos']['db2_client']['file_path']
        db2inst1_home           node['cognos']['db2_client']['db2inst1_home']
        db2_client_password     node['cognos']['db2_client']['db2_client_password']
        action :install_db2_client
end
```
### Catalog Cognos database from database server to Cognos server

```
cognos_catalog_cognos_db "Catalogging COGNOS database" do
  db2_instance_name       node['cognos']['DB2_INSTANCE_NAME']
  db2profile_path         node['cognos']['cognosdb']['DB2PROFILE_PATH']
  cognos_db2_ip        node['cognos']['COGNOS_DB2_IP']
  cognos_db2_port             node['cognos']['COGNOS_DB2_PORT']
  cognos_db_name           node['cognos']['COGNOS_DB_NAME']
  action :catalog_cognos_db
end

```

### To install cognos components we will use default recipe.
On target node run command

chef-client -j /etc/chef/cognos.json ================> This command can be used in HEAT template to execute.
where  cognos.json file contains
 "run_list": [ "recipe[cognos::install]" ]
Example :
root@Jenkins:~# cat /etc/chef/cognos.json
{
  "run_list": [ "recipe[cognos::install]" ]
}


### Recipe to Configure cognos is yet to be done

```
```




