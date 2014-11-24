#
# Cookbook Name:: ucd_deployment_environment
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

## Generate UCD Environment using deployment environment Parameter supplied by user ##
bash "Generate UCD Environment" do
  user "root"
  cwd "/root"
  code <<-EOH
   export JAVA_HOME=/usr/lib/jvm/jre-1.7.0-openjdk.x86_64
   export UDEPLOY_SERVER=50.23.133.186
   echo "{    
	 \\"name\\":\\"#{node['ucd']['environment']}\\",
         \\"application\\":\\"#{node['ucd']['application']}\\",
         \\"blueprint\\":\\"#{node['ucd']['blueprint']}\\",
         \\"baseResource\\":\\"#{node['ucd']['baseResource']}\\"
         }" > deploy_env.json
  ./udclient/udclient -weburl http://$UDEPLOY_SERVER:8080/ -username admin -password admin getEnvironment -application #{node['ucd']['application']} -environment #{node['ucd']['environment']}
  status=$?

  if [ $status -ne 0 ]
  then
    ./udclient/udclient -weburl http://$UDEPLOY_SERVER:8080/ -username admin -password admin provisionEnvironment - deploy_env.json  
  else
   echo "Environment- #{node['ucd']['environment']} already exists"
  fi
  EOH
end
