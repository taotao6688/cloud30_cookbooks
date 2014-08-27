ICA Cookbook
================
Install ICA package and fixpack

Attributes
-----------
* `node['ica']['url']` - The URL which to download ICA and Fixpack packages

Usage
-----
#### ica::default
Install ICA 3.0

#### ica::fixpack
Install ICA 3.0 fixpack 4

e.g.
Just include `ica` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[ica]",
    "recipe[ica::fixpack]"
  ]
}
```

Authors
-------------------
Hitomi Takahashi (hitomi@jp.ibm.com)
