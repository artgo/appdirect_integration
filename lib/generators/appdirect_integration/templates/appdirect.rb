AppdirectIntegration.configure do |c|
  c.appdirect_url = 'https://www.appdirect.com'
  c.order_class = Order
  c.consumer_key = YOUR_CONSUMER_KEY # See Edit Integration part of your Application configuration on AppDirect.
  c.consumer_secret = YOUR_CONSUMER_SECRET # See Edit Integration part of your Application configuration on AppDirect.
end