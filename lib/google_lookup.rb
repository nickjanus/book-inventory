#!/usr/bin/env ruby

module BookInventory
  module Error
    class UnsupportedQuery < Exception; end
    class InvalidIsbn < Exception; end
  end

  #this class for external lookup with Google Books API
  class GoogleLookup
    def self.by_upc
      raise UnsupportedQuery
    end

    def self.by_isbn(isbn)
    end

    def self.by_author_title()
      raise UnsupportedQuery
    end

    prviate
    # @return Hash<symbol, string> 
    def self.lookup(query = {})
      
    end
  end
end
