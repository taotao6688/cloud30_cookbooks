action :install_db2_client do
#	if ::File.exists?("/opt/ibm/db2/V#{new_resource.version}")
#	    puts "\n======================================================="
 #   	    puts "DB2 Client was already installed"
  #          puts "Use `bash /root/chef_db2/db2_uninstall.sh` to uninstall"
   #         puts "========================================================="
#	end

  db2_chef_dir1 = '/opt/ibm/db2/V10.5'
    directory "#{db2_chef_dir1}" do
      owner "root"
      group "root"
      mode "0755"
      recursive true
      action :create
    end
## Download DB2 client installer ##
	 execute "Download db2 client installer" do
        user 'root'
        cwd Chef::Config[:file_cache_path]
        command "wget --user=ftpuser --password=slaas123 ftp://50.22.178.238/artifacts/hcpa/hcpa_installable/db2/client/ibm_data_server_client_linuxx64_v10.5.tar.gz"
        not_if { ::File.exists?("#{Chef::Config[:file_cache_path]}/#{node['cognos']['db2_client_tar']}")}
	notifies :run, "execute[untar-DB2-Client]", :immediately
     end
     execute "untar-DB2-Client" do
       user 'root'
       cwd Chef::Config[:file_cache_path]
       command " tar xzf #{Chef::Config[:file_cache_path]}/#{node['cognos']['db2_client_tar']}; "

     end
    ## Create DB2 Client response file directory ##
    db2_client_dir = '/root/db2_client'
    directory "#{db2_client_dir}" do
      owner "root"
      group "root"
      mode "0755"
      recursive true
      action :create
    end

## Create DB2 repsonse file
    rsp_file = "#{db2_client_dir}/db2_client_install.rsp"
    template "#{rsp_file}" do
      cookbook 'cognos'
      source "db2_client_install.rsp.erb"
      owner "root"
      group "root"
      mode "0644"
      variables(
      :file_path	   => new_resource.file_path,
      :db2inst1_home	   => new_resource.db2inst1_home,
      :db2_client_password => new_resource.db2_client_password
      )
     action :create_if_missing
    end
## Install DB2 Client using response file ##
   db2_client_install_dir="#{Chef::Config[:file_cache_path]}/client"
#   execute "Install db2 client" do
#      cwd "#{db2_client_install_dir}"
#      command "./db2setup -l #{db2_client_dir}/install.log -r #{rsp_file}"
#      returns returns
#   end


  ## installing db2 client 10.5 ##
  ruby_block "installing db2 client 10.5" do
    block do
      db2_client_present = false
      if ::File.exists?("#{new_resource.check_db2_client}")
        cmd_out = %x[ #{new_resource.check_db2_client} ]
        retCode = $?.exitstatus
        if ( retCode == 0 ) then
          db2_client_present = true
        end
      end
      if db2_client_present == false
        Dir.chdir("#{db2_client_install_dir}")
        %x[ ./db2setup -l #{db2_client_dir}/install.log -r #{rsp_file} ]
      else
        puts "\nDB2 Client is already installed here !!!"
      end
    end
    action :create
  end
  
end
