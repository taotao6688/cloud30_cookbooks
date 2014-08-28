# default Biginsights2.1.2 attributes

default['biginsights']['default_pkg']="IS_BIGINSIGHTS_EE_V2.1.2_LNX64.tar.gz"
default['biginsights']['default_dir']="biginsights-enterprise-linux64_b20140318_1321"

# Repository details to install expect, ntp library package
default['biginsights']['repo_dir'] = "/etc/yum.repos.d"
default['biginsights']['name'] = "bi_local.repo"
default['biginsights']['gpgcheck'] = "0"

default['biginsights']['lib_pkg'] = ["expect","ntp"]
