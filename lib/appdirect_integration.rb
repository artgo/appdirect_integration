require 'appdirect_integration/version'
require 'appdirect_integration/engine'

module AppdirectIntegration
	include Configurations

	configurable String, :appdirect_url
  configurable String, :consumer_key
  configurable String, :consumer_secret

  configuration_defaults do |c|
    #c.appdirect_url = 'https://www.appdirect.com'
    c.appdirect_url = 'http://localhost:8080'
  end

  not_configured :consumer_key, :consumer_secret do |prop| # omit the arguments to get a catch-all not_configured
    error :not_configured, "Please configure #{prop} to make AppDirect integration work. Use rake appdirect_integration:install to generate defaults"
    raise ArgumentError, "Please configure #{prop} to make AppDirect integration work. Use rake appdirect_integration:install to generate defaults"
  end
end
