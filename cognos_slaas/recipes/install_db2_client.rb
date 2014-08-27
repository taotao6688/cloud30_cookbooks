#!/usr/bin/ruby
cognos_install_db2_client "Installing DB2 client 10.5" do
	check_db2_client	node['cognos']['db2_client']['check_db2_client']
	file_path		node['cognos']['db2_client']['file_path']
	db2inst1_home		node['cognos']['db2_client']['db2inst1_home']
	db2_client_password	node['cognos']['db2_client']['db2_client_password']
	action :install_db2_client
end
