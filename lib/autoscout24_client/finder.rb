
module Autoscout24Client

  # Contain methods and helpers for fetching vehicles from autoscout24
  module Finder
    module ClassMethods

       # fetches vehicles from autoscout24 using REST api
       # @param [Hash] params filters in autoscout24 hash format
       # @return [Hash] {total_found: integer, vehicles: [Vehicle]}
       def find(params={})
        response = RestClient.post(
            "https://gateway.developer.telekom.com/plone/autoscout24/rest/production/articles",
            prepare_params(params),
            headers()
        )
        json_response = JSON.parse(response)["response"]

        vehicles = json_response["vehicles"]["vehicle"].map {|node| Vehicle.new(node)}
        {total_found: json_response["vehicles_found"], vehicles: vehicles }
      end

      private

       # @return [Hash] default parametrs as hash
       def default_params
        {:culture_id => Autoscout24Client.config[:culture_id]}
      end

      # @param [Hash] params in autoscout24 format with possible 2 shortcuts for page and countries
      # @return [String] string contains params in json format
      # TODO: adjust filter by category
       def prepare_params(params)
        params = Autoscout24Client.config[:default_search_params].merge(params)
        prepared_params = {}

        #let's delete shortcuts first

        # page
        page, per_page = params.delete(:page), params.delete(:per_page){20}
        prepared_params.merge!(paging: {current_page: page, results_per_page: per_page}) if page

        #countries
        countries = params.delete :countries
        prepared_params.merge!(address: {countries: {country_id: countries}}) if countries

        #finally merge raw params in autoscout24 params format
        prepared_params.merge!(params)

        default_params.merge(vehicle_search_parameters: prepared_params).to_json
      end

    end


    def self.included(base)
      base.extend ClassMethods
    end

  end
end
