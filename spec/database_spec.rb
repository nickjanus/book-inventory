#!/usr/bin/env ruby
require 'book_invetory'

good_config = 'spec/data/good_config.yaml'
bad_config = 'spec/data/bad_config.yaml'

describe BI::Database do
  describe '#initialize' do
    context 'with a config' do
      let(:db) {BI::Database.new(good_config)} # no logging for unit tests

      it "creates a connection" do
        expect(db.connection).to be_a(ActiveRecord::ConnectionAdapters::AbstractAdapter)
      end

      it "has a yaml config" do
        expect(db.config).to be_an_instance_of(Hash)
      end
    end
    
    context 'with no config' do
      it "raises an exception" do
        expect{BI::Database.new(nil)}.to raise_error(BI::Error::NoConfig)
      end
    end
  end

  describe "#setup_database" do 
    context 'with a good schema' do
      let(:db) {BI::Database.new(good_config)}
 
      it "executes without incident" do
        expect{db.setup_database}.to_not raise_error 
      end

      before{db.setup_database}
      it "has the right tables" do
        tables = db.tables
        expect(tables.include? 'books').to be true
        expect(tables.include? 'authors').to be true
      end

      it "has a books table with the right columns" do
        columns = db.columns('books').inject([]){|names, col| names << col.name}
        expect(columns.include? 'title').to be true
        expect(columns.include? 'pages').to be true
        expect(columns.include? 'publication_date').to be true
      end
    end

    context 'with a bad schema' do
      let(:db) {BI::Database.new(bad_config)}

      it "raises an exception" do
        expect{db.setup_database}.to raise_error(BI::Error::SchemaDefinition)
      end
    end
  end
end
