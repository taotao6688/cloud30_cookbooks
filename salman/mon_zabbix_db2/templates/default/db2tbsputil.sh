#!/bin/bash
/home/$1/sqllib/bin/db2 CONNECT TO $3 USER $1 USING $2 > /dev/null
/home/$1/sqllib/bin/db2 select "substr(tbsp_name,1,18)",tbsp_type,tbsp_free_size_kb/1024 as tbsp_free_size_MB,tbsp_utilization_percent from sysibmadm.tbsp_utilization | /bin/awk '$1=="IBMDB2SAMPLEREL" {printf "%.2f\n", $3}' 
/home/$1/sqllib/bin/db2 connect reset > /dev/null

