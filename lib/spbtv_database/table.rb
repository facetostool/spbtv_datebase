require 'fileutils'
module Database

  class Table

    attr_reader :rows

    def initialize(source, columns)
      @source = source
      @columns = columns
      #init_table
    end

    def table_file
      unless File.exist? @source[:path]
        FileUtils.touch(@source[:path])
      end
      File.open(@source[:path], 'rb')
    end

    def row_size
      @columns.inject(0) { |sum,column| sum+column[:size] }
    end

    def get_rows
      db_file = table_file
      rows = []
      r_size = row_size
      rows_count = db_file.stat.size/r_size
      keys_array = []
      @columns.each { |column| keys_array << column[:name] }
      rows_count.times do |row_num|
        row = {}
        db_file.pos = row_num*r_size
        unpacked_row = db_file.read(r_size).unpack(unpack_directive)
        keys_array.each_with_index do |key, i|
          row[key] = if key == :date
                       Time.at(unpacked_row[i]).to_date
                     else
                       unpacked_row[i]
                     end
          row[:offset] = row_num
        end
        rows << row
      end
      rows
    end

    def default_directive(type, size = nil)
      case type
        when :integer
          'q'
        when :string
          "A#{size}"
        when :datetime
          'q'
      end
    end

    def unpack_directive
      directive = ''
      @columns.each { |column| directive += default_directive(column[:type], column[:size]) }
      directive
    end

  end

end
