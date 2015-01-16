attribute :db2_client_password,                 	:kind_of => String,     :default => "aq1sw2de"
attribute :file_path,                         		:kind_of => String,     :default => "/opt/ibm/db2/V10.5"
attribute :db2inst1_home,                         	:kind_of => String,     :default => "/home/db2inst1"
attribute :check_db2_client,			:kind_of => String,     :default => "/opt/ibm/db2/V10.5/bin/db2ilist"

actions :install_db2_client
