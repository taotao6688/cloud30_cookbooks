
action :install do

  if ::File.exists?("/opt/ibm/db2/V#{new_resource.version}")
    puts "\n======================================================="
    puts "DB2 was already installed"
    puts "Use `bash /root/chef_db2/db2_uninstall.sh` to uninstall"
    puts "======================================================="
  else
    params = Hash.new()
    attributes = ['version', 'prod', 'port', 'fcm_port', 'max_logical_nodes', 'instance_type', 'instance_username', 'instance_home_dir', 'instance_password', 'fenced_username', 'fenced_password', 'das_username', 'das_password']
    attributes.each do |attribute|
      if new_resource.respond_to?(attribute)
        params[attribute] = new_resource.send(attribute.to_sym) unless new_resource.send(attribute.to_sym).nil?
      end
    end

template "#{node['db2']['repo_dir']}/#{node['db2']['repo_name']}" do
    source 'repo.conf.erb'
    owner 'root'
    group 'root'
    mode '0644'
   
  end

   ##  Install DB2 required packages
    new_resource.req_packages.each do |pkg|
      package pkg do
    action :install
    retries 5
     retry_delay 10
    end
    end

    ## Install DB2 package        

  db2_chef_dir1 = '/opt/ibm/db2/V10.5'
    directory "#{db2_chef_dir1}" do
      owner "root"
      group "root"
      mode "0755"
      recursive true
      action :create
    end


	
  remote_file "#{Chef::Config[:file_cache_path]}/#{node['db2']['db2_tar']}" do

	source "#{node['db2']['ip']}/#{node['db2']['db2_tar']}"

	mode 00755
	notifies :run, "execute[untar-DB2]", :immediately


  end
  

execute "untar-DB2" do

      user 'root'
      cwd Chef::Config[:file_cache_path]
      command " tar xzf #{Chef::Config[:file_cache_path]}/#{node['db2']['db2_tar']}; "
	  
end



    ## Create DB2 response file and uninstall script dir
    db2_chef_dir = '/root/chef_db2'
    directory "#{db2_chef_dir}" do
      owner "root"
      group "root"
      mode "0755"
      recursive true
      action :create
    end

    ## Create DB2 repsonse file
    rsp_file = "#{db2_chef_dir}/db2_install.rsp"
    template "#{rsp_file}" do
      cookbook 'db2'
      source "db2_install.rsp.erb"
      owner "root"
      group "root"
      mode "0644"
      variables(
        "name" => new_resource.name,
        "params" => params
      )
    end

    ## DB2 need this
    bash "Check db2 node hostname" do
      code <<-EOH
      if ! ping -c 1 $(hostname); then
          echo -e "127.0.0.1\t$(hostname)" >> /etc/hosts
      fi
      EOH
    end







    ## Create uninstall DB2 SHELL script
    template "#{db2_chef_dir}/db2_uninstall.sh" do
      cookbook 'db2'
      source "db2_uninstall.sh.erb"
      owner "root"
      group "root"
      mode "0644"
      variables(
        "name" => new_resource.name,
        "params" => params
      )
    end

    ## Install DB2 using response file
    ## Weird, I can't find any error in DB2 v9.7 install log
    ## but db2setup returns a '1' status when installing v9.7, so I added a returns attribute.
    if new_resource.version == "10.5"
      returns = [0, 1]
    else
      returns = [0]
    end
    db2_dir = "#{Chef::Config[:file_cache_path]}/server"
    execute "Install db2" do
	    cwd db2_dir
      command "./db2setup -l #{db2_chef_dir}/install.log -r #{rsp_file}"
      returns returns
	  end

    ## Create ldconfig file
    ldconf = '/etc/ld.so.conf.d/db2.conf'
    template "#{ldconf}" do
      cookbook 'db2'
      source "db2.conf.erb"
      owner "root"
      group "root"
      mode "0644"
      variables(
        "name" => new_resource.name,
        "params" => params
      )
      # notifies :run, 'execute[ldconfig]', :immediately
    end

    execute "ldconfig" do
      command "ldconfig"
    end

    ## Create db2.service in init.d dir
    template "/etc/rc.d/init.d/db2.service" do
      cookbook 'db2'
      source 'db2.service.erb'
      owner 'root'
      group 'root'
      mode '0755'
      variables(
        'name' => new_resource.name,
        'params' => params
      )
    end

    ## Add autostart after reboot
    link '/etc/rc.d/rc3.d/S27db2.service' do
      link_type :symbolic
      to '/etc/rc.d/init.d/db2.service'
      not_if 'test -L /etc/rc.d/rc3.d/S27db2.service'
    end

  end

end

action :restart do
  execute "stop db2 instance service" do
    command "su - #{new_resource.instance_username} -c 'db2stop'"
    ignore_failure true
  end

  execute "start db2 instance service" do
    command "su - #{new_resource.instance_username} -c 'db2start'"
    ignore_failure true
  end
end
