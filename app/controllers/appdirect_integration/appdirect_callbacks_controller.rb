require 'oauth'
require 'rest-client'
require 'appdirect_integration'

module AppdirectIntegration
  class AppdirectCallbacksController < ApplicationController
    def order
      puts "Received order from AppDirect, requesting info..."

      site = AppdirectIntegration.configuration.appdirect_url
      path = "/api/integration/v1/events/#{token}"

      puts "Basic path #{site}#{path}"

      consumer = OAuth::Consumer.new(AppdirectIntegration.configuration.consumer_key.to_s,
                                     AppdirectIntegration.configuration.consumer_secret.to_s, {
                                       :site => site,
      :scheme => :query_string })
      req = consumer.create_signed_request(:get, path)
      full_path = "#{site}#{req.path}"

      puts "Requesting #{full_path}"

      result = RestClient.get full_path, :content_type => :json, :accept => :json

      puts "JSON Result: #{result.to_s}"

      parsed_result = ActiveSupport::JSON.decode(result.to_s)

      params = convert_to_params(parsed_result)

      order = AppdirectIntegration.configuration.order_class.new(params)

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

    def notify
      puts "notify"
      render xml: success_response('Account creation successful', '123')
    end

    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def token
      params[:token]
    end

    def convert_to_params(parsed_result)
      company = parsed_result["payload"]["company"]
      user = parsed_result["creator"]
      order_data = parsed_result["payload"]["order"]

      company_name = company["name"]
      company_email = company["email"]
      company_email = user["email"] if company_email.blank?
      company_phone = company["phoneNumber"]
      user_name = "#{user["firstName"]} #{user["lastName"]}"
      quantity = order_data["items"][0]["quantity"]
      edition = order_data["editionCode"]

      {
        company_name: company_name,
        company_email: company_email,
        company_phone: company_phone,
        user_name: user_name,
        quantity: quantity,
        edition: edition,
        status: 'ACTIVE'
      }
    end

    def success_response(message, account_id)
      {success: true, message: message, accountIdentifier: account_id}.to_xml(root: 'result')
    end

    def fault_response(message, error_code)
      {success: false, errorCode: error_code, message: message}.to_xml(root: 'result')
    end
  end
end
