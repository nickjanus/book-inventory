#!/usr/bin/env ruby
require 'active_record'
require 'yaml'

module Database
  module Errors
    class SchemaDefinition < Exception {}
  end

  class DbUtil
    def intialization
      @config = YAML::load(File.open('../config/config.yml'))
      ActiveRecord::Base.logger = Logger.new(File.open('database.log', 'w'))
      ActiveRecord::Base.establish_connection(
        :adapter  => @confg[:adapter],
        :database => @config[:db_path]
      )
      @connection = ActiveRecord::Base.connection
    end

    def setup_database 
      import_schema(File.open(@config[:schema_path]))
    end

    def import_schema(yaml_file)
      schema = YAML::load(yaml_file)
    
      begin
        schema.each do |table, columns|
          unless @connection.tables.include? table
            create_table table.to_sym do |table|
              columns.each do |column, type|
                table.column (column, type)
              end
            end
          end
        end
      rescue => e
        raise Errors::SchemaDefinition(e.message)
      end
    end
  end
end
