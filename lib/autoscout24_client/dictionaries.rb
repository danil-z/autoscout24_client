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
        RestClient.post(
            "#{Autoscout24Client::BASE_URL}/makeModelTree",
            default_params, headers ) { |response, request, result, &block|
            case response.code
              when 200
                JSON.parse(response)["response"]["stx3_idpool"]["nodes"]["node"]
              when 401
                if JSON.parse(response)["status"]["statusCode"] == "0040"
                  reset_token
                  fetch_make_model_tree
                end
              else
                raise
            end
        }
      end


      # fetches LookUpData from autoscout24
      # http://www.developergarden.com/fileadmin/microsites/ApiProject/Dokumente/Dokumentation/Api_Doc_4_1/telekom-api-rest-4.1/html/as24_get_look_up_data.html
      # @return [Hash]
      def fetch_look_up_data
        RestClient.post(
            "#{Autoscout24Client::BASE_URL}/lookUpData",
            default_params,headers) { |response, request, result, &block|
            case response.code
              when 200
                JSON.parse(response)["response"]["stx3_idpool"]["elements"]["element"]
              when 401
                if JSON.parse(response)["status"]["statusCode"] == "0040"
                  reset_token
                  fetch_look_up_data
                end
              else
                raise
            end
        }
       end
    end

    def self.included(base)
      base.extend ClassMethods
    end

  end
end
