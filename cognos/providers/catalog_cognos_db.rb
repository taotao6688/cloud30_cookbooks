action :catalog_cognos_db do

## catalog COGNOS db ##
## Note:- Do not do indentation of this resource at all ##
bash "catalog COGNOS database" do
code <<-EOH
su - -s /bin/bash #{new_resource.db2_instance_name} -c "$(cat <<EOC
source #{new_resource.db2profile_path}
echo 'Sourced db2profile successfully'

echo "Creating COGNOS database catalog ..."

db2 CATALOG TCPIP NODE COGNOSNODE REMOTE #{new_resource.db2_ip} SERVER #{new_resource.db2_port}
db2 CATALOG DATABASE #{new_resource.cognos_dbname} AT NODE COGNOSNODE
db2 TERMINATE

echo "Done"

touch /tmp/cognos_db_already_cataloged

EOC
)"

EOH
action :run
not_if " test -e /tmp/cognos_db_already_cataloged "
end

## Update JDBC driver file ##
cognos_lib_dir="/opt/ibm/cognos/c10_64/webapps/p2pd/WEB-INF/lib"
jdbc_driver_dir="/home/db2inst1/sqllib/java"
execute "Copying JDBC driver files to Cognos library" do
cwd "#{jdbc_driver_dir}"
command "cp -f db2jcc.jar db2jcc_license_cu.jar db2java.jar #{cognos_lib_dir}"
not_if {::File.exists?("{cognos_lib_dir}/db2jcc.jar")}
end


end
