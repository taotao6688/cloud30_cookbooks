Filenet Cookbook
================
Install Filenet P8 and Content Search Services (CSS) and configure WAS properties.

Attributes
----------
* `node['filenet']['url']` - The URL which to download Filenet, Fixpack and CSS packages


Usage
-----
#### filenet::default
Install Filnet P8 Version 5.2

#### filenet::css
Install Content Search Services (CSS) 

#### filenet::post_config
Configure WAS for Filenet P8

#### filenet::fixpack_cpe
Apply Content Platform Engine 5.2 fixpack 3

#### filenet::fixpack_cpec
Apply Content Platform Engine Client 5.2 fixpack 3

#### filenet::fixpack_css
Apply Content Search Service 5.2.0.2 FP2

#### filenet::fixpack_navi
Apply Content Navigator 2.0.2

#### filenet::fixpack_xt
Apply Workplace XT 1.1.5.2

e.g.
Just include `filenet` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[filenet]",
    "recipe[filenet::css]",
    "recipe[filenet::post_config]", 
    "recipe[filenet::fixpack_cpe]", 
    "recipe[filenet::fixpack_cpec]", 
    "recipe[filenet::fixpack_css]", 
    "recipe[filenet::fixpack_navi]",
    "recipe[filenet::fixpack_xt]"
  ]
}
```

License and Authors
-------------------
Hitomi Takahashi (hitomi@jp.ibm.com)