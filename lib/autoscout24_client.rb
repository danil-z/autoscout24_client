require "rest-client"
require "json"

require "autoscout24_client/version"
require "autoscout24_client/authorization"
require "autoscout24_client/dictionaries"
require "autoscout24_client/finder"
require "autoscout24_client/vehicle"

require "logger"
require 'yaml'

module Autoscout24Client
  BASE_URL =  "https://gateway.developer.telekom.com/plone/autoscout24/rest/production"

  @config = {
      :username => ENV["AUTOSCOUT24_USERNAME"],
      :password => ENV["AUTOSCOUT24_PASSWORD"],
      :culture_id => "de-DE",
      :default_search_params => {per_page: 20}
  }

  @valid_config_keys = @config.keys

  # Configure through hash
  def self.configure(opts = {})
    opts.each {|k,v| @config[k.to_sym] = v if @valid_config_keys.include? k.to_sym}
  end

  # Configure through yaml file
  def self.configure_with(path_to_yaml_file)
    logger = Logger.new(STDOUT)
    begin
      config = YAML::load(IO.read(path_to_yaml_file))
    rescue Errno::ENOENT
      logger.warn("YAML configuration file couldn't be found. Using defaults.") unless ENV['CI']; return
    rescue Psych::SyntaxError
      logger.warn("YAML configuration file contains invalid syntax. Using defaults.") unless ENV['CI']; return
    end

    configure(config)
  end

  def self.config
    @config
  end

end
