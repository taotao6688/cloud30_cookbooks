action :install do  


##  Install Cognos required packages
if node[:platform_version] == "6.5"
node['cognos']['REQUIRED_PACKAGES_32_BIT'].each do |req_pkg|
    yum_package req_pkg do
      retries 5
      retry_delay 10
      not_if " rpm -q #{req_pkg} "
    end
  end
    new_resource.req_packages.each do |pkg|
      package pkg do
    action :install
    retries 5
     retry_delay 10
    end
    end
end
# command "wget http://10.28.216.79:8080/cognos/#{node['cognos']['cognos_tar']}"
 ## Download Cognos BI Installer ##
    execute "Download cognos installer" do
        user 'root'
        cwd Chef::Config[:file_cache_path]
	command "wget --user=ftpuser --password=slaas123 ftp://50.22.178.238/artifacts/chef_installable/cognos/#{node['cognos']['cognos_tar']}"
        notifies :run, "execute[untar-cognos]", :immediately
    end

    ## Extract the Cognos BI installer ##
    execute "untar-cognos" do
        user 'root'
        cwd Chef::Config[:file_cache_path]
        command " tar xzf #{Chef::Config[:file_cache_path]}/#{node['cognos']['cognos_tar']}; "
    end

   ## Create Cognos response file and uninstall script dir
    cognos_chef_dir = '/root/chef_cognos'
    directory "#{cognos_chef_dir}" do
      owner "root"
      group "root"
      mode "0755"
      recursive true
      action :create
    end

    ## Create DB2 repsonse file
    rsp_file = "#{cognos_chef_dir}/cognos_install.ats"
    template "#{rsp_file}" do
      cookbook 'cognos'
      source "cognos_install.ats.erb"
      owner "root"
      group "root"
      mode "0644"
      variables(
        "agreement" => new_resource.agreement,
	"install_dir" => new_resource.install_dir,
        "bi_server" => new_resource.bi_server,
        "backup" => new_resource.backup,
	"application_tier" => new_resource.application_tier,
	"gateway" => new_resource.gateway,
	"content_manager" => new_resource.content_manager,
	"content_database" => new_resource.content_database
      )
    end

    ## Install now the cognos server components using response file ##
    ## Use umask 022 to the installation directory here::::>>>> REMEMBER
    cognos_dir = "#{Chef::Config[:file_cache_path]}/linuxi38664h"
    execute "Install Cognos server components" do
      cwd "#{cognos_dir}"
      command "./issetupnx -s #{rsp_file}"
    end

    ## Copy global configuration file to cognos configuration directory ##
    ##cookbook_file "/path/to/c10_location/configuration/cogstartup.xml" do
    #   source "cogstartup.xml"
    #   mode 00755
    #end

    ## Configure the installed cognos components ##
    #cognos_config_dir = "/path/to/c10_location/bin64"
    #execute "Configure Cognos server components" do
    #  cwd cognos_config_dir
    #  command "./cogconfig.sh -s"
    #  returns returns

    #end
    execute "Removing installer from cognos server" do
      cwd {Chef::Config[:file_cache_path]}
      command "rm -rf #{node['cognos']['cognos_tar']}"
    end
end
