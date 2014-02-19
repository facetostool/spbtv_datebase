module Database

  class TableConfiguration

    def initialize(&block)
      @source = {}
      @columns = []
      instance_eval(&block)
    end

    def source(type, path)
      @source = {type: type, path: path}
    end

    def column(name, type, size = nil)
      @columns <<  { name: name, type: type,  size: default_size(type, size)}
    end

    def get_source
      @source
    end

    def get_columns
      @columns
    end

    private

    def default_size(type, size)
      size ||= case type
                 when :integer
                   8
                 when :string
                   255
                 when :datetime
                   8
                 else
                   raise "Don't know default binary size for #{type}"
               end
    end

  end

end