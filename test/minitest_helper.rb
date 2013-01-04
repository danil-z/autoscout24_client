ENV["RAILS_ENV"] = "test"

require 'simplecov'
SimpleCov.start

require File.expand_path("../../lib/autoscout24", __FILE__)
require "minitest/autorun"

require 'webmock/minitest'
