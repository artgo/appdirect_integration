require 'appdirect_integration/version'
require 'appdirect_integration/engine'
require 'appdirect_integration/configuration'

module AppdirectIntegration
  mattr_accessor :configuration

  def self.configure(&block)
    self.configuration ||= Configuration.new
    self.configuration.appdirect_url = 'https://www.appdirect.com'
    block.call self.configuration
    #if self.configuration.order_class.nil?
    #  raise "Please configure order_class to make AppDirect integration work. Use rake appdirect_integration:install to generate defaults"
    #end
    #if self.configuration.consumer_key.nil?
    #  raise "Please configure consumer_key to make AppDirect integration work. Use rake appdirect_integration:install to generate defaults"
    #end
    #if self.configuration.consumer_secret.nil?
    #  raise "Please configure consumer_secret to make AppDirect integration work. Use rake appdirect_integration:install to generate defaults"
    #end
  end
end
