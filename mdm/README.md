MDM Cookbook
=============
Install Master Data Management (MDM). This software requires 2nodes, DB2 node and WAS ND node.

Attributes
----------
* `node['mdm']['url']` - The URL which to download MDM packages
* `node['mdm']['dpip']` - IP Address of DB2 node

Usage
-----
#### mdm::db2_install
Install DB2 node

#### mdm::db2_setup
Configure DB2 for MDM

#### mdm::was_nd_install
Install WAS ND

#### mdm::db2_client_install
Install DB2 Client 

#### mdm::sudo
Configure SUDO operation for MDM

#### mdm::setup_was
Install MDM on WAS ND


Install DB2 node first. After that, install MDM node.

`run_list` for DB2 Node:

```json
{
  "name":"mdm_db2",
  "run_list": [
    "recipe[mdm::db2_install]",
    "recipe[mdm::db2_setup]"
  ]
}
```

`run_list` for WAS ND/MDM Node:

```json
{
  "name":"mdm_was",
  "run_list": [
    "recipe[mdm::was_nd_install]",
    "recipe[mdm::db2_client_install]",
    "recipe[mdm::sudo]",
    "recipe[mdm::setup_was]"
  ]
}
```

License and Authors
-------------------
Hitomi Takahashi (hitomi@jp.ibm.com)