#!/usr/bin/env ruby

require 'isbn'

module BookInventory
  module Error
    class RecordNotFound < Exception; end
  end

  class Record
    # @param fields (Array<symbol>) fields the record should have
    # @param data (Hash<symbol, string>) :ISBN or :UPC required for data retrieval
    def initialize(data, fields)

    end

    # @return (Array<:symbols>) empty fields
    def check_fields

    end

    def to_hash

    end
  end
end
