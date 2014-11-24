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

