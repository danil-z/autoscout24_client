require 'active_support/core_ext/string'

module Autoscout24Client

  # Dictionaries module mixin handles fetching dictionaries from autoscout24(makeModelTree,LookUpData)
  # also provides class methods to access dictionaries like body_color, body, country, equipment,
  # fuel, gear_type, body_painting, brand, model, model_line, category
  module Dictionaries
    module ClassMethods

      # This is main sets for autoscout24 definitions
      # TODO: probably remove name key from hash
      #class << self
      %w(body_color body country equipment fuel gear_type body_painting brand model model_line category).each do |meth|
        define_method(meth.pluralize) {
          class_variable_get("@@#{meth.pluralize}") rescue
              class_variable_set("@@#{meth.pluralize}",
                                 look_up_data.select{|node| node["name"] == (meth =="gear_type" ? meth.pluralize : meth) })
        }
      end

      #end


      # makeModelTree from autoscout24
      # http://www.developergarden.com/fileadmin/microsites/ApiProject/Dokumente/Dokumentation/Api_Doc_4_1/telekom-api-rest-4.1/html/as24_get_make_model_tree.html
      # @return [Hash]
      def make_model_tree
        @@make_model_tree ||= self.fetch_make_model_tree
      end

      # LookUpData from autoscout24
      # http://www.developergarden.com/fileadmin/microsites/ApiProject/Dokumente/Dokumentation/Api_Doc_4_1/telekom-api-rest-4.1/html/as24_get_look_up_data.html
      # @return [Hash]
      def look_up_data
        @@look_up_data ||= self.fetch_look_up_data
      end



      # fetches makeModelTree from autoscout24
      # http://www.developergarden.com/fileadmin/microsites/ApiProject/Dokumente/Dokumentation/Api_Doc_4_1/telekom-api-rest-4.1/html/as24_get_make_model_tree.html
      # @return [Hash]
      def fetch_make_model_tree
        fetch("makeModelTree","node")
      end


      # fetches LookUpData from autoscout24
      # http://www.developergarden.com/okumentation/Api_Doc_4_1/telekom-api-rest-4.1/html/as24_get_look_up_data.html
      # @return [Hash]
      def fetch_look_up_data
        fetch("lookUpData","element")
      end

      def fetch(path, node)
        response = RestClient.post("#{Autoscout24Client::BASE_URL}/#{path}", default_params,headers) {|response, request, result| response }
        begin
          parsed_json = JSON.parse(response)
          reset_token if parsed_json["status"]["statusCode"] == "0040"
          parsed_json["response"]["stx3_idpool"][node.pluralize][node]
        rescue
          nil
        end
      end
    end

    def self.included(base)
      base.extend ClassMethods
    end

  end
end
