cognos_catalog_cognos_db "Catalogging COGNOS database" do

  db2_instance_name       node['cognos']['DB2_INSTANCE_NAME']
  db2profile_path         node['cognos']['cognosdb']['DB2PROFILE_PATH']
  cognos_db2_ip        node['cognos']['COGNOS_DB2_IP']
  cognos_db2_port             node['cognos']['COGNOS_DB2_PORT']
  cognos_db_name           node['cognos']['COGNOS_DB_NAME']

  action :catalog_cognos_db

end
