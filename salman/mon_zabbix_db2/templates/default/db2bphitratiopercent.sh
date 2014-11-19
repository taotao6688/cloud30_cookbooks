#!/bin/bash
/home/$1/sqllib/bin/db2 CONNECT TO $3 USER $1 USING $2 > /dev/null
/home/$1/sqllib/bin/db2 "select substr(bp_name,1,30) as bp_name, COALESCE(total_hit_ratio_percent, 0) as total_hit_ratio_percent from sysibmadm.bp_hitratio where bp_name not like 'IBMSYSTEM%'" | /bin/awk '$1=="IBMDEFAULTBP"  {printf "%.2f\n", $2}'
/home/$1/sqllib/bin/db2 connect reset > /dev/null

