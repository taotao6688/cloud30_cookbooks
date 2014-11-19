#
# Cookbook Name:: filenet
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute


case node["ica"]["version"]
  when "3.0"
	script_file = "ICA_config.sh"
  when "3.5"
	script_file = "WCA_config.sh"
end

directory "/var/package" do
        owner "root"
	group "root"
	action :create
end

directory "/var/package/ica" do
        owner "root"
	group "root"
	action :create
end

remote_file "/var/package/ica_lib.tgz" do
  source "#{node["ica"]["url"]}/ica_lib.tgz"
end

bash "expand_ica_lib_files" do 
	user "root" 
	cwd "/var/package/" 
	code <<-EOH 
	tar zxvf ica_lib.tgz
	EOH
end

remote_file "/var/package/ica_lib/#{script_file}" do
  mode "0755"
  source "#{node["ica"]["url"]}/#{script_file}"
end


bash "copy_lib" do 
	user "root" 
	code <<-EOH 
	su - esadmin -l -c 'cp -f /var/package/ica/ica_lib/lib/ICAExportPlugins.jar /opt/IBM/es/lib '
	su - esadmin -l -c 'cp -f /var/package/ica/ica_lib/lib/JSON4.jar /opt/IBM/es/lib '
	cd /opt/IBM/es/configurations/interfaces
	sed -i -e "s/classpath.*//" indexservice__interface.ini
	echo "classpath=es.indexservice.jar,antlr-2.7.2.jar,cloudscape/lib/derbyclient.jar,cloudscape/lib/derby.jar,an_icm.jar,es.dock.jar,oze_search.jar,wlp/dev/api/spec/com.ibm.ws.javaee.servlet.3.0_1.0.1.jar,es.rdf.jar,/opt/IBM/FileNet/CEClient/lib/Jace.jar,/opt/IBM/FileNet/CEClient/lib/log4j.jar,/opt/IBM/FileNet/CEClient/lib/stax-api.jar,/opt/IBM/FileNet/CEClient/lib/xlxpScanner.jar,/opt/IBM/FileNet/CEClient/lib/xlxpScannerUtils.jar" >>  indexservice__interface.ini
	sed -i -e "s/classpath.*//" exporter__interface.ini
	echo "classpath=es.oss.jar,esctrl.jar,es.indexservice.jar,cloudscape/lib/derbyclient.jar,cloudscape/lib/derby.jar,cloudscape/lib/derbyclient.jar,esapi.jar,uima_core.jar,ilel-crawler.jar,es.crawler.jar,es.rdf.jar,es.rdf.tool.jar,mail.jar,siapi.jar,/opt/IBM/FileNet/CEClient/lib/Jace.jar,/opt/IBM/FileNet/CEClient/lib/log4j.jar,/opt/IBM/FileNet/CEClient/lib/stax-api.jar,/opt/IBM/FileNet/CEClient/lib/xlxpScanner.jar,/opt/IBM/FileNet/CEClient/lib/xlxpScannerUtils.jar" >> exporter__interface.ini
	su - esadmin -l -c '/opt/IBM/es/bin/esadmin system stopall || echo'
	su - esadmin -l -c '/opt/IBM/es/bin/esadmin system startall || echo'
	EOH
end
bash "start_ica" do 
	user "root" 
	code <<-EOH 
	su - esadmin -l -c 'cp -f /var/package/ica/ica_lib/*.jar /opt/IBM/es/lib '
	cd /var/package/ica_lib
	priip=$(ifconfig eth1 | grep 'inet addr:' | sed -e 's/^.*inet addr://' -e 's/ .*//')
	./#{script_file} $priip #{node["ica"]["filenet_addr"]}
	su - esadmin -l -c '/opt/IBM/es/bin/esadmin system stopall || echo'
	su - esadmin -l -c '/opt/IBM/es/bin/esadmin system startall || echo'
	EOH
end
