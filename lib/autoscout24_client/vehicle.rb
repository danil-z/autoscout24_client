

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

    # TODO: refactor this 3 methods into 1

    # @return [String] name of fuel_type
    def fuel
      @fuel ||= self.class.fuels.find{|fuels| fuels["id"]==source["fuel_type_id"]}["text"] if source["fuel_type_id"]
    end

    # @return [String] name of gear_type
    def gear_type
      @gear_type ||= self.class.gear_types.find{|gears| gears["id"]==source["gear_type_id"]}["text"] if source["gear_type_id"]
    end

    # @return [String] name of brand like BMW, Audi and etc
    def brand
      @brand ||= self.class.brands.find{|node| node["id"]==source["brand_id"].to_s}["text"] if source['brand_id']
    end

    # seems we have this value in response
    ## @return [String] name of body_color
    #def body_color
    #  @body_color ||= self.class.body_colors.find{|body_color| body_color["id"]==source["body_colorgroup_id"]}["text"] if source['body_colorgroup_id']
    #end

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
