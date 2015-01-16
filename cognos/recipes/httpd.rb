     package "httpd" 


    ## Directory to keep rpms of Apache server ##
   apache_dir="#{Chef::Config[:file_cache_path]}/apache"
   directory "#{apache_dir}" do
      owner "root"
      group "root"
      mode "0755"
      recursive true
      action :create
   end

    ## Start Apache Web Server ##
  execute "Start Apache web server" do
    cwd "#{apache_dir}"
    user 'root'
    command " /etc/init.d/httpd start "
  end

    ## Configure Apache web server COGNOS BI ##
  cookbook_file "Copying apache server cofiguration script for cognos" do
    path "#{apache_dir}/HttpCongnosConfig.sh"
    source "HttpCongnosConfig.sh"
    owner "root"
    group "root"
    mode "0777"
    action :create
  end

  ## Configure Apache web server COGNOS BI ##
  execute "Run Apache server configuration script for cognos" do
    cwd "#{apache_dir}"
    command " ./HttpCongnosConfig.sh "
    action :run
  end

  ## Restart Apache web server ##
  execute "Restart Apache web server" do
    cwd "#{apache_dir}"
    user 'root'
    command " /etc/init.d/httpd restart "
  end

  
  execute "Remove directory for Apache" do
    command "rm -rf #{apache_dir}"
  end

