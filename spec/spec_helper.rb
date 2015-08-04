ENV["RAILS_ENV"] = "test"

$:.unshift File.dirname(__FILE__)
require "dummy/config/environment"
require 'appdirect_integration'
