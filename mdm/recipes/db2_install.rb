directory "/var/package" do
        owner "root"
        group "root"
        action :create
end

directory "/var/package/db2" do
        owner "root"
        group "root"
        action :create
end

remote_file "/var/package/db2/DB2_Svr_V10.5_Linux_x86-64.tar.gz" do
  source "#{node["mdm"]["url"]}/DB2_Svr_V10.5_Linux_x86-64.tar.gz"
end


db2_install_location="/opt/ibm/db2/V10.5/"
pkg_location="/var/package/db2"

db2file = "DB2_Svr_V10.5_Linux_x86-64.tar.gz"
db2rsp = "db2ese.rsp"

group "db2iadm1" do
  action :create
  gid 999
end

group "db2fadm1" do
  action :create
  gid 998
end

group "dasadm1" do
  action :create
  gid 997
end

user "db2inst1" do
  uid 1004
  gid "db2iadm1"
  home "/home/db2inst1"
end

user "db2fenc1" do
  uid 1003
  gid "db2fadm1"
  home "/home/db2fenc1"
end

user "dasusr1" do
  uid 1002
  gid "dasadm1"
  home "/home/dasusr1"
end

package "pam" do
   action :install
end

bash "set_password" do
        user "root"
        code <<-EOH
        echo "db2inst1:db2inst1" | chpasswd
        EOH
end

template "/var/package/db2/#{db2rsp}" do
  source "db2_10_5_rsp.erb"
  owner "root"
  group "root"
end


bash "install_db2" do
        user "root"
        cwd "#{pkg_location}"
        code <<-EOH
        tar zxvf #{db2file}
        server/db2setup -r #{db2rsp} || echo
        EOH
end

