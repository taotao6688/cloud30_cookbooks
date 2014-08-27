# required option
default['db2']['das_password'] = 'passw0rd'
default['db2']['instance_password'] = 'passw0rd'
default['db2']['fenced_password'] = 'passw0rd'

default['db2']['db_name'] = "testdb"
# default['db2']['db_schema'] = "dbschema"
# default['db2']['db_user'] = "dbuser"
# default['db2']['db_pass'] = "passw0rd"
# 
 default['db2']['ha_vip'] = '172.16.1.151'
 default['db2']['primary_host'] = "172.16.1.151"
# default['db2']['standby_host'] = "172.16.1.26"
 default['db2']['primary_port'] = 10000
# default['db2']['standby_port'] = 10000
default['DB2']['config_dir'] = "/opt/ibm/db2/V10.5"
#default['db2']['ip']="172.16.0.1"
#default['db2']['ip']="50.23.133.189"
default['db2']['ip']="10.28.216.79"
#default['db2']['db2_tar']="DB2_Svr_V10.5_Linux_x86-64.tar.gz"
default['db2']['db2_tar']="v10.5fp3_linuxx64_server.tar.gz"
default['db2']['repo_dir'] = "/etc/yum.repos.d"
#default['db2']['repo_dir']="/etc/apt/sources.list"
default['db2']['name'] = "CentOS-6.4-x86_64.repo"
default['db2']['baseurl'] = "http://172.16.0.10:8080/redhat/rhel/6Server/x86_64/"
#default['db2']['baseurl']="http://131.246.123.4:8080/debian"
#default['db2']['baseurl'] = "http://50.22.178.238:8080/debian"
default['db2']['gpgcheck'] = "0"

# optional options
default['db2']['version'] = "10.5"
default['db2']['port'] = 50000
default['db2']['fcm_port'] = 60000
default['db2']['max_logical_nodes'] = 4
default['db2']['instance_type'] = "ESE"
default['db2']['instance_home_dir'] = "/home/db2inst1"
default['db2']['instance_username'] = "db2inst1"
default['db2']['fenced_username'] = "db2fenc1"
default['db2']['das_username'] = "db2das1"
default['db2']['package'] = "ibm-db2"
default['db2']['req_packages'] = ["libaio", "dapl", "sg3_utils", "libibcm", "ibsim", "ibutils", "libcxgb3", "libipathverbs", "libibmad", "libibumad", "libipathverbs", "libmthca", "libnes", "rdma"]
#default['db2']['req_packages'] = %w()
default['db2']['prod'] = 'ENTERPRISE_SERVER_EDITION'
if node['db2']['version'] == "10.5"
  default['db2']['prod'] = 'DB2_SERVER_EDITION'
end

#if (node.name.include? 'tds' or node.name.include? 'utd')
  #default['db2']['url'] = "http://cwr01/yum/middleware/5Server/x86_64/DB2_ESE_97_Linux_x86-64.tar"
#  default['db2']['req_packages'] = ["libaio", "dapl", "sg3_utils", "libibcm", "ibsim", "ibutils", "libcxgb3", "libipathverbs", "libibmad", "libibumad", "libipathverbs", "libmthca", "libnes" ]
#else 
#  default['db2']['url'] = "http://172.16.0.1/DB2_Svr_V10.5_Linux_x86-64.tar.gz"
#  default['db2']['req_packages'] = ["libaio", "dapl", "sg3_utils", "libibcm", "ibsim", "ibutils", "libcxgb3", "libipathverbs", "libibmad", "libibumad", "libipathverbs", "libmthca", "libnes", "rdma" ]
#default['db2']['req_packages'] = %w()
#end
if platform?("redhat", "centos", "fedora")
default['db2']['req_packages'] = ["libaio", "dapl", "sg3_utils", "libibcm", "ibsim", "ibutils", "libcxgb3", "libipathverbs", "libibmad", "libibumad", "libipathverbs", "libmthca", "libnes", "rdma" ]
end

if platform?("ubuntu")
default['db2']['req_packages'] = ["libpam0g:i386", "lib32stdc++6", "libaio1" ]
end

