require 'spbtv_datebase/table'
require 'spbtv_datebase/request'
require 'spbtv_datebase/table_initializer'
require 'spbtv_datebase/version'


module Database

  extend self
  @@connections = {}

  def define_connection(name, &block)
    @@connections[name] = TableInitializer.new(&block)
  end

  def connect(name)
    @@connections[name]
  end

end