#!usr/bin/env ruby

require 'util'
require 'csv'
require 'yaml'

module BookInventory
  module Error
    class FileFormatNotSupported < Exception; end
  end
  
  #Separated Value File Reader
  class SvfReader
    attr_reader :entries, :file_format, :map

    def initialize(file_extension, map_file)
      case file_extension
      when 'csv'
        separator = ','
      when 'tab'
        separator = '\t'
      else
        raise Error::FileFormatNotSupported.new("Only .csv and .tab files are supported.")
      end
      
      map_file = YAML::load(File.open(Util::get_path(map_file)))
      @map =  map_file['Map'].inject({}){|map, column| map[column] = map_file['mapping'][column]}
      @has_headers = map_file['Headers']
      @options = { :col_sep => separator, 
                   :headers => @has_headers}
    end

    def import(file_path)
      rows = CSV.read(file_path,@options)

      headers = rows[0]
      items = rows[1..-1]

      @entries = @entries.inject(items) do |items_array, item|
        entry.each_index do|index| 
          key = @has_headers ? @map[headers[index].to_s] : @map[index]
          item_hash[key] = items[index] 
        end
        items_array << item_hash
      end
    end
  end
end
