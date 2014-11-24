#
# Cookbook Name:: ucd_agent
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
artifact_server="#{node['ucd_agent']['artifact_server']}"
udeploy_server="#{node['ucd_agent']['udeploy_server']}"
agent_name="#{node['ucd_agent']['name']}"
java_home="#{node['ucd_agent']['java_home']}"
bash "Install ucd agent" do
  user "root"
  cwd "/root"
  code <<-EOH
  export JAVA_HOME=#{java_home}
  wget --user=ftpuser --password=slaas123 ftp://#{artifact_server}/artifacts/urban_code/udclient.zip
  unzip udclient.zip
  echo "#{udeploy_server} ucd61.slaas.ibm.com ucd61" >> /etc/hosts
  wget --user=ftpuser --password=slaas123 ftp://#{artifact_server}/artifacts/urban_code/ud_server.key
  cat ud_server.key >> .ssh/authorized_keys
  ipaddr=$(ifconfig eth1 | grep 'inet addr:' | sed -e 's/^.*inet addr://' -e 's/ .*//')
  ./udclient/udclient -weburl http://#{udeploy_server}:8080/ -username admin -password admin installAgent -name #{agent_name} -host $ipaddr -port 22 -sshUsername root -installDir /opt/ibm-ucd/agent -javaHomePath #{java_home} -tempDirPath /tmp -serverHost #{udeploy_server} -serverPort 7918
  
  # Verify Installed Agent
  sleep 5
  ./udclient/udclient -weburl http://#{udeploy_server}:8080/ -username admin -password admin testAgent -agent #{agent_name} > agent_status.log
  grep -q "OK" agent_status.log
  ucd_state=$?
  if [ $ucd_state -eq 0 ]
  then
    echo "UCD Agent - #{agent_name} is available"
  else
    /opt/ibm-ucd/agent/bin/agent stop
    sleep 5
    /opt/ibm-ucd/agent/bin/agent start
    sleep 5
    ./udclient/udclient -weburl http://#{udeploy_server}:8080/ -username admin -password admin testAgent -agent #{agent_name} > agent_retry_status.log
    grep -q "OK" agent_retry_status.log
    rerun_state=$?
    if [ $rerun_state -eq 0 ]
    then
      echo "UCD Agent - #{agent_name} is available"
    else
      echo "UCD Agent - #{agent_name} is not available"
    fi
  fi

  EOH
end

