
module Autoscout24Client

  # Authorization module mixin handles all authorization logic
  module Authorization
    module ClassMethods

      private

      # security token for header in each request
      # @return [String] token base64 string
      def token
        @@token ||= fetch_token
      end

      # fetches from remote server security token (needed for header in each futher request)
      # uses username and password provided by config
      # @return [String] token base64 string
      def fetch_token
        response = RestClient.get "https://#{Autoscout24Client.config[:username]}:#{Autoscout24Client.config[:password]}@sts.idm.telekom.com/rest-v1/tokens/odg", {:accept => :json}
        JSON.parse(response)["token"]
      end

      # resets token
      # TODO: use this if request fails cause of expired token
      def reset_token
        @@token = nil
      end

      # generates security headers  used in POST request to autoscout24
      def headers
        {:content_type => :json, :accept => :json, :authorization => "TAuth realm=\"https://odg.t-online.de\",tauth_token=\"#{token}\""}
      end

    end

    def self.included(base)
      base.extend ClassMethods
    end

  end
end