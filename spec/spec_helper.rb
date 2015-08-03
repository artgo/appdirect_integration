ENV["RAILS_ENV"] = "test"

$:.unshift File.dirname(__FILE__)
require "dummy/config/environment"
require "rails/test_help"
require 'appdirect_integration'
