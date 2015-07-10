require 'oauth'
require 'net/http'
require 'appdirect_integration'

module AppdirectIntegration
  class AppdirectCallbacksController < ApplicationController
    def order
      puts "Received order from AppDirect, requesting info..."

      #event_url = "#{AppdirectIntegration.configuration.appdirect_url}/api/integration/v1/events/#{token}"
      site = AppdirectIntegration.configuration.appdirect_url
      path = "/api/integration/v1/events/#{token}"

      puts "Basic path #{site}#{path}"

      consumer = OAuth::Consumer.new(AppdirectIntegration.configuration.consumer_key.to_s,
                                     AppdirectIntegration.configuration.consumer_secret.to_s, {
                                       :site => site,
                                       :scheme => :query_string })
      req = consumer.create_signed_request(:get, path)

      puts "Requesting #{site}#{req.path}"

      result = Net::HTTP.get(URI.parse(site), req.path)

      puts "XML Result: #{result.to_s}"

      parsed_result = Hash.from_xml(result)

      puts "Parsed json result: #{parsed_result.to_s}"

      company = parsed_result[:event][:payload][:company]
      user = parsed_result[:event][:creator]
      order_data = parsed_result[:event][:payload][:order]

      order = AppdirectIntegration.configuration.order_class.new({
                                                                   company_name: company[:name],
                                                                   company_email: company[:email],
                                                                   company_phone: company[:phone],
                                                                   user_name: "#{user[:firstName]} #{user[:lastName]}",
                                                                   quantity: order_data[:item][0][:quantity]
      })

      if order.save
        render xml: success_response('Account creation successful', order.id.to_s)
      else
        render xml: fault_response('Error creating account', 'UNKNOWN_ERROR')
      end
    end

    def change
      puts "change"
      render xml: success_response('Account creation successful', '123')
    end

    def cancel
      puts "cancel"
      render xml: success_response('Account creation successful', '123')
    end

    def status
      puts "status"
      render xml: success_response('Account creation successful', '123')
    end

    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def token
      params[:token]
    end

    def success_response(message, account_id)
      {success: true, message: message, accountIdentifier: account_id}.to_xml(root: 'result')
    end

    def fault_response(message, error_code)
      {success: false, errorCode: error_code, message: message}.to_xml(root: 'result')
    end
  end
end
