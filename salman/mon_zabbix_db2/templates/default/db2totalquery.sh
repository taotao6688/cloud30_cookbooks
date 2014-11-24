#!/bin/bash
cd /home/$1
/home/$1/sqllib/bin/db2 -x CONNECT TO $3 USER $1 using $2 > /dev/null
/home/$1/sqllib/bin/db2  SELECT "substr('TOTALQUERY',1,10)", TOTAL_APP_COMMITS FROM SYSIBMADM.MON_DB_SUMMARY | /bin/awk '$1=="TOTALQUERY" {printf "%0.f\n", $2}'
/home/$1/sqllib/bin/db2 -x connect reset > /dev/null

