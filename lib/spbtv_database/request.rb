module Database

  class Request

    ROWS_GETTING_COUNT = 100

    def initialize(table)
      @table = table
    end

    def where(options, limit)
      limit ||= 1
      result = recursive_find(@table.get_rows, options)
      result[0..limit-1]
    end

    def recursive_find(rows, options)
      found_rows = rows
      unless options.empty?
        key = options.keys.first
        value = options.values.first
        found_rows = rows.find_all {|line| line[key] == value  }
        options.delete(key)
        recursive_find(found_rows, options)
      end
      found_rows
    end

    def value(value)
      case value
        when String
          "'" + value + "'"
        when Fixnum
          value
      end
    end

    def method_missing(name, *args, &block)
      p "Don't know option:  #{name}!"
      super
    end

  end
end
