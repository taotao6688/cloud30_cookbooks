#
# Cookbook Name:: tomcat7
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

#       wget http://www.us.apache.org/dist/tomcat/tomcat-7/v7.0.56/bin/apache-tomcat-7.0.56.tar.gz

bash "Install tomcat7" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64
  wget --user=ftpuser --password=slaas123 ftp://50.22.178.238/artifacts/chef_installable/apache-tomcat-7.0.56.tar.gz
  tar -xzf apache-tomcat-7.0.56.tar.gz
  mv apache-tomcat-7.0.56 /usr/local/tomcat7
  echo "<?xml version='1.0' encoding='utf-8'?>" > /usr/local/tomcat7/conf/tomcat-users.xml
  echo '<tomcat-users>' >> /usr/local/tomcat7/conf/tomcat-users.xml
  echo '<role rolename="manager-gui"/>' >> /usr/local/tomcat7/conf/tomcat-users.xml
  echo '<user username="admin" password="sl44sr0t" roles="manager-gui"/>' >> /usr/local/tomcat7/conf/tomcat-users.xml
  echo '</tomcat-users>' >> /usr/local/tomcat7/conf/tomcat-users.xml
  cd /usr/local/tomcat7
  ./bin/startup.sh
  EOH
end

execute "Remove Tomcat installer" do
  user "root"
  cwd "/tmp"
  command "rm -rf apache-tomcat-7.0.56.tar.gz"
end

#only_if { ::File.exists?("apache-tomcat-7.0.56.tar.gz")}
