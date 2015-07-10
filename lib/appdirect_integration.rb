require 'appdirect_integration/version'
require 'appdirect_integration/engine'
require 'appdirect_integration/configuration'

module AppdirectIntegration
  mattr_reader :configuration

  def self.configure(&block)
    self.configuration ||= Configuration.new
    block.call self.configuration
  end


  # configuration_defaults do |c|
  #   c.appdirect_url = 'https://www.appdirect.com'
  # end

  # not_configured :consumer_key, :consumer_secret, :order_class do |prop| # omit the arguments to get a catch-all not_configured
  #   puts "Please configure #{prop} to make AppDirect integration work. Use rake appdirect_integration:install to generate defaults"
  #   raise ArgumentError, "Please configure #{prop} to make AppDirect integration work. Use rake appdirect_integration:install to generate defaults"
  # end
end
