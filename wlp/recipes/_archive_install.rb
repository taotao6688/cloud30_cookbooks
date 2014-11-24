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

=begin
#<
Installs WebSphere Application Server Liberty Profile from jar archive files. 
This recipe is called by the `default` recipe and should not be used directly.
#>
=end

unless node[:wlp][:archive][:base_url]
  raise "You must specify the base URL location to download WebSphere Application Server Liberty Profile archives."
end

unless node[:wlp][:archive][:accept_license]
  raise "You must accept the license to install WebSphere Application Server Liberty Profile."
end

runtime_dir = "#{node[:wlp][:base_dir]}/wlp"
runtime_uri = ::URI.parse(node[:wlp][:archive][:runtime][:url])
runtime_filename = ::File.basename(runtime_uri.path)

# Fetch the WAS Liberty Profile runtime file
if runtime_uri.scheme == "file"
  runtime_file = runtime_uri.path
else
  runtime_file = "#{Chef::Config[:file_cache_path]}/#{runtime_filename}"
  remote_file runtime_file do
    source node[:wlp][:archive][:runtime][:url]
    user node[:wlp][:user]
    group node[:wlp][:group]
    checksum node[:wlp][:archive][:runtime][:checksum]
    not_if { ::File.exists?(runtime_dir) }
  end
end



# Install the WAS Liberty Profile
execute "install #{runtime_filename}" do
  cwd node[:wlp][:base_dir]
  command "java -jar #{runtime_file} --acceptLicense #{node[:wlp][:base_dir]}" 
  user node[:wlp][:user]
  group node[:wlp][:group]
  not_if { ::File.exists?(runtime_dir) }
end




