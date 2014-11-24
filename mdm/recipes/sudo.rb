bash "ssh_config" do
        user "root"
        code <<-EOH
        sed -i 's/Defaults    requiretty/#Defaults    requiretty/' /etc/sudoers
        EOH
end

