# Cookbook Name:: wlp
# Attributes:: default
#
# (C) Copyright IBM Corporation 2013.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#<> User name under which the server is installed and runs.
default[:wlp][:user] = "wlp"

#<> Group name under which the server is installed and runs.
default[:wlp][:group] = "wlp-admin"

#<
# Use the `java` cookbook to install Java. If Java is installed using a different method  
# set it to `false`. The Java executables must be available on the __PATH__. 
#>
default[:wlp][:install_java] = false

#<> Base installation directory.
default[:wlp][:base_dir] = "/opt/was/liberty"

#<> Set user configuration directory (wlp.user.dir). Set to 'nil' to use default location.
default[:wlp][:user_dir] = nil

#<> Installation method. Set it to 'archive' or 'zip'.
default[:wlp][:install_method] = 'archive'

#<
# Base URL location for downloading the runtime, extended, and extras Liberty profile archives. 
# Must be set when `node[:wlp][:install_method]` is set to `archive`. 
#>
default[:wlp][:archive][:base_url] = "#{node[wlp_archive]['sourcepath']}"

#<> URL location of the runtime archive.
default[:wlp][:archive][:runtime][:url] = "#{node[:wlp][:archive][:base_url]}/wlp-developers-runtime-8.5.5.3.jar"

#<> Checksum value for the runtime archive.
default[:wlp][:archive][:runtime][:checksum] = 'd3e78cb43ab6392175807b54495bc8996ec9bc7b33cd1fc9699de3e74a9696bc'
                                                
#<> URL location of the extended archive.
#default[:wlp][:archive][:extended][:url] = "#{node[:wlp][:archive][:base_url]}/wlp-developers-extended-8.5.5.2.jar"

#<> Checksum value for the extended archive.
#default[:wlp][:archive][:extended][:checksum] = 'b4cd9ae8716073ef4c6a2181f7201a31d2c24cfd55337694f09bed7715548ca3'

#<> Controls whether the extended archive is downloaded and installed.
#default[:wlp][:archive][:extended][:install] = true

#<> URL location of the extras archive.
#default[:wlp][:archive][:extras][:url] = "#{node[:wlp][:archive][:base_url]}/wlp-developers-extras-8.5.5.2.jar"

#<> Checksum value for the extras archive.
#default[:wlp][:archive][:extras][:checksum] = 'b99a6b4e501c7c6214db49342d198d9949b60b6017f9f75692fd562295ebc11a'

#<> Controls whether the extras archive is downloaded and installed.
#default[:wlp][:archive][:extras][:install] = false

#<> Base installation directory of the extras archive. 
#default[:wlp][:archive][:extras][:base_dir] = "#{node[:wlp][:base_dir]}/extras"

#<
# Accept license terms when doing archive-based installation. 
# Must be set to `true` or the installation fails. 
#>
default[:wlp][:archive][:accept_license] = true

#<
# URL location for a zip file containing Liberty profile installation files. Must be set 
# if `node[:wlp][:install_method]` is set to `zip`.
#>
default[:wlp][:zip][:url] = nil

#<> Defines a basic server configuration when creating server instances using the `wlp_server` resource.
default[:wlp][:config][:basic] = {
  "featureManager" => {
    "feature" => [ "jsp-2.2" ]
  },
  "httpEndpoint" => {
    "id" => "defaultHttpEndpoint",
    "host" => "*",
    "httpPort" => "9080",
    "httpsPort" => "9443"
  }
}
