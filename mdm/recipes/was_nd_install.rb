directory "/var/package" do
        owner "root"
        group "root"
        action :create
end

directory "/var/package/was8" do
        owner "root"
        group "root"
        action :create
end

directory "/var/package/was8/installer" do
        owner "root"
        group "root"
        action :create
end
directory "/var/package/was8/fix" do
        owner "root"
        group "root"
        action :create
end

directory "/var/package/was8/was8" do
        owner "root"
        group "root"
        action :create
end

remote_file "/var/package/was8/fix/8.5.5-WS-WAS-FP0000002-part1.zip" do
  source "#{node["mdm"]["url"]}/8.5.5-WS-WAS-FP0000002-part1.zip"
end

remote_file "/var/package/was8/fix/8.5.5-WS-WAS-FP0000002-part2.zip" do
  source "#{node["mdm"]["url"]}/8.5.5-WS-WAS-FP0000002-part2.zip"
end

remote_file "/var/package/was8/installer/InstalMgr1.6.2_LNX_X86_WAS_8.5.5.zip" do
  source "#{node["mdm"]["url"]}/InstalMgr1.6.2_LNX_X86_WAS_8.5.5.zip"
end

remote_file "/var/package/was8/was8/WAS_ND_V8.5.5_1_OF_3.zip" do
  source "#{node["mdm"]["url"]}/WAS_ND_V8.5.5_1_OF_3.zip"
end

remote_file "/var/package/was8/was8/WAS_ND_V8.5.5_2_OF_3.zip" do
  source "#{node["mdm"]["url"]}/WAS_ND_V8.5.5_2_OF_3.zip"
end

remote_file "/var/package/was8/was8/WAS_ND_V8.5.5_3_OF_3.zip" do
  source "#{node["mdm"]["url"]}/WAS_ND_V8.5.5_3_OF_3.zip"
end

bash "yum_update" do
        user "root"
        code <<-EOH
        yum update -y
        EOH
end

package "libstdc++" do
  action :install
end

yum_package "libstdc++" do
  arch "i686"
  action :install
end

package "ksh" do
  action :install
end

pkgroot = "/var/package/was8"

user "mdmadmin" do
  action :create
end

bash "set_password" do
        user "root"
        code <<-EOH
        echo "mdmadmin:mdmadmin" | chpasswd
        EOH
end

bash "change_owner" do
        user "root"
        code <<-EOH
	chown mdmadmin:mdmadmin -R /var/package
	chown mdmadmin:mdmadmin -R /opt
        EOH
end

remote_file "/var/package/was8/installer/install.xml" do
  source "#{node["mdm"]["url"]}/install.xml"
  user "mdmadmin"
  group "mdmadmin"
end

bash "install_installer" do
        user "mdmadmin"
	group "mdmadmin"
        cwd "#{pkgroot}/installer"
        code <<-EOH
        unzip InstalMgr1.6.2_LNX_X86_WAS_8.5.5.zip
        ./userinstc -acceptLicense -log install_log
        EOH
end

bash "unzip_was" do
        user "mdmadmin"
	group "mdmadmin"
        cwd "#{pkgroot}/was8"
        code <<-EOH
	unzip WAS_ND_V8.5.5_1_OF_3.zip
	unzip WAS_ND_V8.5.5_2_OF_3.zip
	unzip WAS_ND_V8.5.5_3_OF_3.zip
        EOH
end

bash "unzip_wasfix" do
        user "mdmadmin"
	group "mdmadmin"
        cwd "#{pkgroot}/fix"
        code <<-EOH
        unzip 8.5.5-WS-WAS-FP0000002-part1.zip
        unzip 8.5.5-WS-WAS-FP0000002-part2.zip
        EOH
end

template "/var/package/was8/was8_nd.rsp" do
  source "was_nd_rsp.erb"
  user "mdmadmin"
  group "mdmadmin"
end

bash "install_was" do
  	user "mdmadmin"
	group "mdmadmin"
        cwd "#{pkgroot}"
        code <<-EOH
        /opt/IBM/InstallationManager/eclipse/tools/imcl input /var/package/was8/was8_nd.rsp -log /opt/IBM/InstallationManager/WAS_SILENT_LOG -acceptLicense
        EOH
end
