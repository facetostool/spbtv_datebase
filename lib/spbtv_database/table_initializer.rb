module Database

  class TableInitializer

    attr_reader :tables

    def initialize(&block)
      @tables = []
      instance_eval(&block)
    end

    def table(name, &block)
      t_config = TableConfiguration.new(&block)
      @tables << {name: name, table: Table.new(t_config.get_source, t_config.get_columns)}
    end

    def select(name, options)
      table = @tables.find{ |table| table[:name] == name }[:table]
      request = Request.new(table)
      request.send(options.keys.first, options.values.first, options[:limit])
    end

  end

end