require 'appdirect_integration/version'
require 'appdirect_integration/engine'
require 'configurations'

module AppdirectIntegration
	include Configurations

	configurable String, :appdirect_url
  configurable String, :consumer_key
  configurable String, :consumer_secret
  configurable Class, :order_class

  configuration_defaults do |c|
    c.appdirect_url = 'https://www.appdirect.com'
  end

  not_configured :consumer_key, :consumer_secret, :order_class do |prop| # omit the arguments to get a catch-all not_configured
    error :not_configured, "Please configure #{prop} to make AppDirect integration work. Use rake appdirect_integration:install to generate defaults"
    raise ArgumentError, "Please configure #{prop} to make AppDirect integration work. Use rake appdirect_integration:install to generate defaults"
  end
end
