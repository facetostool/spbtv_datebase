module Database

  class TableInitializer

    include Request

    attr_reader :tables

    def initialize(&block)
      @tables = []
      instance_eval(&block)
    end

    def table(name, &block)
      @tables << {name: name, table: Table.new(&block)}
    end

  end

end