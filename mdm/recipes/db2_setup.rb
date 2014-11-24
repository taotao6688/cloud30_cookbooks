remote_file "/var/package/db2/mdm.tgz" do
  source "#{node["mdm"]["url"]}/mdm.tgz"
end

pkg_location="/var/package/db2"

bash "create_db" do
        user "root"
        cwd "#{pkg_location}"
        code <<-EOH
        tar zxvf mdm.tgz
	cd mdm
	./createDatabase.sh      
        EOH
end

