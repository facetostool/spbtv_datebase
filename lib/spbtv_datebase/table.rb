require 'fileutils'
module Database

  class Table

    attr_reader :rows

    def initialize(&block)
      @rows = []
      @columns = []
      instance_eval(&block)
      init_table
    end

    def init_table
      unless File.exist? @source[:path]
        FileUtils.touch(@source[:path])
      end
      @db_file = File.open(@source[:path], 'rb')
      read_rows
    end

    def row_size
      @columns.inject(0) { |sum,column| sum+column[:size] }
    end

    def read_rows
      r_size = row_size
      rows_count = @db_file.stat.size/r_size
      keys_array = []
      @columns.each { |column| keys_array << column[:name] }
      rows_count.times do |row_num|
        row = {}
        @db_file.pos = row_num*r_size
        unpacked_row = @db_file.read(r_size).unpack(unpack_directive)
        keys_array.each_with_index do |key, i|
          row[key] = if key == :date
                       Time.at(unpacked_row[i]).to_date
                     else
                       unpacked_row[i]
                     end
          row[:offset] = row_num
        end
        @rows << row
      end
    end

    def source(type, path)
      @source = {type: type, path: path}
    end

    def column(name, type, size = nil)
      @columns <<  { name: name, type: type,  size: default_size(type, size)}
    end

    def check_init_errors
      fail 'You need init columns' if @columns.empty?
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
          fail "Don't know default binary size for #{type}"
      end
    end

    def default_directive(type, size = nil)
      case type
        when :integer
          'q'
        when :string
          "A#{default_size(type, size)}"
        when :datetime
          'q'
        else
          fail "Don't know directive for #{type}"
      end
    end

    def unpack_directive
      directive = ''
      @columns.each { |column| directive += default_directive(column[:type], column[:size]) }
      directive
    end

  end

end

#    a50          q         q
#    50 bytes
#   string    integer  datetime
#{name: '', number: '', date: ''}
#{name: '', number: '', date: ''}
#{name: '', number: '', date: ''}
