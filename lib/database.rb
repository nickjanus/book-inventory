#!/usr/bin/env ruby

require 'util'
require 'active_record'
require 'yaml'
require 'set'

module BookInventory
  module Error
    class YamlSyntax < Exception; end
    class SchemaDefinition < Exception; end
    class NoConfig < Exception; end
  end

  class Database 
    attr_reader :connection, :config, :db

    def initialize(config = 'config/config.yml', log = 'database.log')
      raise Error::NoConfig unless config
      @config = YAML::load(File.open(Util::get_path(config)))
      @db = Util::get_path(@config['db'])
      ActiveRecord::Base.logger = Logger.new(File.open(log, 'w')) unless log.nil?
      ActiveRecord::Base.establish_connection(
        :adapter  => @config['adapter'],
        :database => @db
      )
      @connection = ActiveRecord::Base.connection
    end

    def setup_database 
      import_schema(File.open(Util::get_path(@config['schema'])))
    end

    def import_schema(yaml_file)
      begin
        schema = YAML::load(yaml_file)
      rescue => e
        raise Error::YamlSyntax.new(e.message)
      end

      begin
        connection = @connection #instance variable not recognized in block below
        ActiveRecord::Schema.define do
          schema.each do |table_name, columns|
            unless connection.tables.include? table_name #function specific to sqlite3 adapter
              create_table table_name do |table|
                columns.each do |column_name, type|
                  table.column(column_name, type)
                end
              end
            end
          end
        end
      rescue => e
        raise Error::SchemaDefinition.new(e.message)
      ensure
        delete
      end
    end

    def tables
      @connection.tables
    end

    def columns(table_name)
      @connection.columns(table_name)
    end

    def delete
        File.delete(@db) if File.exist?(@db)
    end
  end
end
