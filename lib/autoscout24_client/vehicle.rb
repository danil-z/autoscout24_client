

module Autoscout24Client

  class Vehicle

    # all authorization logic
    include Authorization

    # all dictionaries
    include Dictionaries

    # main module for fetching vehicles using REST
    # find method
    include Finder

    # raw hash from autoscout24
    attr_accessor :source

    def initialize(node={})
      @source = node
    end

    ## @return [String] name of gear_type
    def gear_type
      @gear_type ||= generic_finder :gear_types, "gear_type_id"
    end

    ## @return [String] name of brand
    def brand
      @brand ||= generic_finder :brands, "brand_id"
    end

    ## @return [String] name of fuel_type
    def fuel
      @fuel ||= generic_finder :fuels, "fuel_type_id"
    end

    def generic_finder(collection, primary_key)
      self.class.send(collection).each do |object|
        return object["text"] if object["id"] == source[primary_key]
      end if source[primary_key]
      nil
    end

    # shortcuts for simple data
    %w(mileage accident_free body_color kilowatt).each do |meth|
      define_method(meth){source[meth]}
    end

    #  hash helpers
    ## TODO: move this to external file
    ## recursively search hash for key value match
    #def self.dfs(hsh, &blk)
    #  return enum_for(:dfs, hsh) unless blk
    #
    #  yield hsh
    #  hsh.each do |k,v|
    #    if v.is_a? Array
    #      v.each do |elm|
    #        dfs(elm, &blk)
    #      end
    #    end
    #  end
    #end
    #
    #def self.find_by_key(hsh, key, search_for)
    #  dfs(hsh).find {|node| node[key] == search_for }
    #end
    #

  end
end
