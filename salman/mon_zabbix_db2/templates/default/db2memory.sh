#!/bin/bash
cd /home/$1
/home/$1/sqllib/bin/db2 -x CONNECT TO $3 USER $1 using $2 > /dev/null
/home/$1/sqllib/bin/db2 -x select pool_id,pool_secondary_id,pool_cur_size,pool_watermark from sysibmadm.snapdb_memory_pool | /bin/awk '$1=="DATABASE" {printf "%0.f\n", $4}'
/home/$1/sqllib/bin/db2 -x connect reset > /dev/null

