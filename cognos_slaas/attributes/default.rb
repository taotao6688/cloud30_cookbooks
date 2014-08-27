#required option
default['cognos']['ip']="10.28.216.79"
default['cognos']['cognos_tar']="bi_svr_10.2.1_l86_ml.tar.gz"
default['cognos']['user']="cognos"
default['cognos']['group']="cognos"

## Installation  Response file variable ##
default['cognos']['license']['agreement']="y"
default['cognos']['install_dir']="/opt/ibm/cognos/c10_64"

## Components variable to be installed ##
## 0 if not to be installed in the same VM , 1 if to install on same VM ##
default['cognos']['bi_server']="1"
default['cognos']['backup']="0"
default['cognos']['application_tier']="1"
default['cognos']['gateway']="1"
default['cognos']['content_manager']="1"
default['cognos']['content_database']="1"

## Cognos Version ##
default['cognos']['version'] = "10.2.1"

## Required packages ##
default['cognos']['REQUIRED_PACKAGES_32_BIT'] = ["glibc.i686", "nss-softokn-freebl.i686", "gtk2.i686", "libXtst.i686"]
default['cognos']['req_packages'] = ["glibc.i686", "libfreebl3.so", "nss-softokn-freebl.i686", "libgcc", "gtk2.i686", "libXtst.i686"]

## FTP Server variables ##
default['ftp']['url']="ftp://50.22.178.238/artifacts"
default['ftp']['user']="ftpuser"
default['ftp']['password']="slaas123"

## Apache server variables ##
default['apache']['apache_tar']="httpd.tar"
default['apache']['installable_dir']="#{node['ftp']['url']}/hcpa/hcpa_installable/httpd"

## DB2 Client Variables ##
default['cognos']['db2_client']['install_dir']=""
default['cognos']['db2_client_tar']="ibm_data_server_client_linuxx64_v10.5.tar.gz"
default['cognos']['db2_client']['file_path']="/opt/ibm/db2/V10.5"
default['cognos']['db2_client']['db2inst1_home']="/home/db2inst1"
default['cognos']['db2_client']['check_db2_client']="#{node['cognos']['db2_client']['file_path']}/bin/db2ilist"
default['cognos']['db2_client']['db2_client_password']="aq1sw2de"

## Variables for Catalog database ##

default['cognos']['DB2_INSTANCE_NAME']="db2inst1"
default['cognos']['cognosdb']['DB2PROFILE_PATH']="/home/db2inst1/sqllib/db2profile"
default['cognos']['COGNOS_DB2_IP']=""
default['cognos']['COGNOS_DB2_PORT']="50000"
default['cognos']['COGNOS_DB_NAME']="cognos"
