
actions :install, :restart

def initialize(*args)
  super
  @action = :install
end

attribute :version, :kind_of => String, :equal_to => ["10.2.1"], :required => false
attribute :agreement, :kind_of => String, :default => "y", :required => true
attribute :install_dir, :kind_of => String, :default => "/opt/ibm/cognos/c10_64" ,:required => true
attribute :bi_server, :kind_of => String, :default => "1", :required => true
attribute :backup, :kind_of => String, :default => "0", :required => false
attribute :application_tier, :kind_of => String, :default => "1", :required => true
attribute :gateway, :kind_of => String, :default => "1", :required => true
attribute :content_manager, :kind_of => String, :default => "1", :required => true
attribute :content_database, :kind_of => String, :default => "1", :required => true
attribute :req_packages, :kind_of => Array, :default => ["glibc.i686", "libfreebl3.so", "nss-softokn-freebl.i686", "libgcc", "/lib/ld-linux.so.2"], :required => false
