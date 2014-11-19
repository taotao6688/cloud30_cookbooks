ICA Cookbook
================
Install ICA 3.0 package and its fixpack or Install WCA 3.5

Attributes
-----------
* `node['ica']['url']` - The URL which to download ICA and Fixpack packages
* `node['ica']['version']` - Installation version (3.0 or 3.5)


Usage
-----
#### ica::default
Install ICA 3.0 or WCA 3.5


#### ica::fixpack
Install ICA 3.0 fixpack 4

e.g.
Just include `ica` in your node's `run_list` when you install ICA 3.0:

```json
{
  "run_list": [
    "recipe[ica]",
    "recipe[ica::fixpack]"
  ]
}
```
When you install WCA 3.5, `run_list` is the following:

```json
{
  "ica" : { 
    "version" : "3.5"
  }, 
  "run_list": [
    "recipe[ica]"
  ]
}
```

Authors
-------------------
Hitomi Takahashi (hitomi@jp.ibm.com)