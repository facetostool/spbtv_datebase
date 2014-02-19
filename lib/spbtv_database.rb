require 'spbtv_database/table'
require 'spbtv_database/request'
require 'spbtv_database/table_initializer'
require 'spbtv_database/version'
require 'spbtv_database/table_configuration'

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

