module Database

  module Request

    def select(name, options)
      @table = @tables.find{ |table| table[:name] == name }[:table]
      send(options.keys.first, options.values.first, options[:limit])
    end

    def where(options, limit)
      limit ||= 1
      request = ''
      options.each_with_index do |opt, i|
        if i == 0
          request += "line[:#{opt[0]}] == #{value(opt[1])}"
        else
          request += " and line[:#{opt[0]}] == #{value(opt[1])}"
        end
      end
      result = @table.rows.find_all {|line| eval(request)  }
      result[0..limit-1]
    end

    def value(value)
      tp = value.class
      case value
        when String
          "'" + value + "'"
        when Fixnum
          value
        else
          fail "Don't know value #{value.class}!"
      end
    end

    def method_missing(name, *args, &block)
      p "Don't know option:  #{name}!"
      super
    end

  end
end
