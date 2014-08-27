
actions :enable 

def initialize(*args)
  super
  @action = :enable
end

attribute :database_username, :kind_of => String, :required => true
attribute :database_name, :kind_of => String, :required => true
attribute :database_host, :kind_of => String, :required => true
attribute :database_port, :kind_of => String, :required => true
attribute :database_user_password, :kind_of => String, :required => true
attribute :database_mongo_port, :kind_of => String, :required => true

attribute :instance_username, :kind_of => String, :default => "db2inst1", :required => false
