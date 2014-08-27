#!/bin/bash
# Script add servername and update directory section to point cognos server in in http.conf file 
# Script logs execution result at /tmp/httpConf.log 
# Author : Ashish Shrivastava
# Date : 8/01/2014
echo "Starting http configuration" > /tmp/httpConf.log
echo "--------------------------------" >> /tmp/httpConf.log
echo "Adding serverName in /etc/httpd/conf/httpd.conf" >> /tmp/httpConf.log
isExits=`cat /etc/httpd/conf/httpd.conf | grep ServerName | grep  localhost`
if [ -z "$isExits" ]
then

        sed -i '/www.example.com:80/a\ServerName localhost' /etc/httpd/conf/httpd.conf
                echo "Complete adding entry in file" >> /tmp/httpConf.log
else
                echo "Entry already found in file" >> /tmp/httpConf.log
fi
echo "---------------------------------------------------------" >> /tmp/httpConf.log

echo "Checking if apache server configuration present or not" >> /tmp/httpConf.log
isApacheConfig=`cat /etc/httpd/conf/httpd.conf | grep ibmcognos`
if [ -z "$isApacheConfig" ]
then
	echo "Apache server configuration is not present , adding entries" >> /tmp/httpConf.log
	echo "Creating Apache Server Configuration file  " >> /tmp/httpConf.log
	cat <<EOT > /tmp/apacheServerConfiguration
	# For Cognos
	ScriptAlias /ibmcognos/cgi-bin "/opt/ibm/cognos/c10_64/cgi-bin/"
	newline
	<Directory "/opt/ibm/cognos/c10_64/cgi-bin/">
	1234AllowOverride None
	1234Options None
	1234Order Allow,Deny
	1234Allow from All
	</Directory>
	newline
	Alias /ibmcognos "/opt/ibm/cognos/c10_64/webcontent/"
	newline
	<Directory "/opt/ibm/cognos/c10_64/webcontent/">
	1234AllowOverride None
	1234Options Indexes MultiViews
	1234Order Allow,Deny
	1234Allow from All
	</Directory>
EOT
	
	echo "Created file /tmp/apacheServerConfiguration file" >> /tmp/httpConf.log
	echo "Editing /etc/httpd/conf/httpd.conf file" >> /tmp/httpConf.log

	count=1
	while read line
	do
			count=$((count + 1 ))
			#echo $line
			if [ "$line" == "Options None" ]
			then
					echo $line
					fseek=$((count + 4))
			fi
	done < /etc/httpd/conf/httpd.conf

	while read line
	do
			echo "sed -i '"$fseek"i"$line"' /etc/httpd/conf/httpd.conf" > /tmp/sedCmd.sh
			chmod +x /tmp/sedCmd.sh
			sh /tmp/sedCmd.sh
			fseek=$((fseek + 1 ))
	done < /tmp/apacheServerConfiguration
	sed -i 's/newline//g' /etc/httpd/conf/httpd.conf
	sed -i 's/1234/    /g' /etc/httpd/conf/httpd.conf

	echo "Completed editing /etc/httpd/conf/httpd.conf file" >> /tmp/httpConf.log 
	
else
	
	echo "Apache server configuration is already present , skipping adding section " >> /tmp/httpConf.log 
	
fi


echo "---------------------------------------------------------" >> /tmp/httpConf.log
echo "Restarting httpd server" >> /tmp/httpConf.log
/etc/init.d/httpd restart

echo "--------------------------------" >> /tmp/httpConf.log
echo "Completed http configuration" >> /tmp/httpConf.log


