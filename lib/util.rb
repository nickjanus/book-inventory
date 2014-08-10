#!/usr/bin/env ruby

module BookInventory
  module Util
    def self.get_path(project_path)
      File.expand_path('../../' + project_path , __FILE__)
    end

    def self.get_extension(path)
      path[-3..-1].downcase
    end
  end
end
