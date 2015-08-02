AppdirectIntegration.configure do |c|
  c.order_class = Order # Order model, refer another one if you are using other model.
  c.consumer_key = ENV['APPDIRECT_CONSUMER_KEY'] # See Edit Integration part of your Application configuration on AppDirect.
  c.consumer_secret = ENV['APPDIRECT_CONSUMER_SECRET'] # See Edit Integration part of your Application configuration on AppDirect.
end
