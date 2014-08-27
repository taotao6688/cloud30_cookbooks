Filenet Cookbook
================
Install Filenet P8 and Content Search Services (CSS) and configure WAS properties.

Attributes
----------
* `node['filenet']['url']` - The URL which to download Filenet and CSS packages


Usage
-----
#### filenet::default
Install Filnet P8 Version 5.2

#### filenet::css
Install Content Search Services (CSS) 

#### filenet::post_config
Configure WAS for Filenet P8

e.g.
Just include `filenet` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[filenet]",
    "recipe[filenet::css]",
    "recipe[filenet::post_config]"
  ]
}
```

License and Authors
-------------------
Hitomi Takahashi (hitomi@jp.ibm.com)
