#
# Cookbook Name:: slaas_basics
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
## Installs basic yum packages ##
x_window_system="X Window System"
execute "Updating the installed packages" do
  command "yum update -y; yum groupinstall -y '#{x_window_system}' Desktop"
end

execute "Install gnome" do
  command "yum -y install gnome-system-monitor"
end

#%w{tigervnc-server tigervnc-server-module libXfont pixman xterm xorg-x11-twm}.each do |pkg|
#  yum_package pkg do
#    retries 5
#    retry_delay 10
#  end
#end
%w{java-1.7.0-openjdk-devel firefox icedtea-web gedit}.each do |pkg|
  package pkg do
  retries 5
  retry_delay 10
  end
end
execute "Install required packages" do
  command "yum groupinstall -y  'Development Tools' --skip-broken"
end

## Install expect ##
package "expect"
