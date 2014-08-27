attribute :db2_instance_name,		:kind_of => String,     :default => "db2inst1"
attribute :db2profile_path,           	:kind_of => String,     :default => "/home/db2inst1/sqllib/db2profile"
attribute :cognos_db2_ip,           	:kind_of => String,     :default => "#{node['cognos']['COGNOS_DB2_IP']}"
attribute :cognos_db2_port,           	:kind_of => String,     :default => "50000"
attribute :cognos_db_name,           	:kind_of => String,     :default => "cognos"

actions :catalog_cognos_db
