require 'oauth'
require 'rest-client'
require 'uri'
require 'appdirect_integration'
require 'appdirect_integration/util'

module AppdirectIntegration
  class AppdirectCallbacksController < ApplicationController
    def order
      puts "Received order from AppDirect, requesting info..."

      parsed_result = read_event_data()

      order = AppdirectIntegration.configuration.order_class.new
      order = build_order_object(parsed_result, order)
      order.status = 'ACTIVE' if order.respond_to?('status=')

      if order.save
        render json: success_response('Account creation successful', order.id.to_s)
      else
        render json: fault_response('Error creating account', 'UNKNOWN_ERROR')
      end
    end

    def change
      puts "Received order from AppDirect, requesting info..."

      parsed_result = read_event_data()

      id = parsed_result["payload"]["account"]["accountIdentifier"]

      order = AppdirectIntegration.configuration.order_class.find(id)
      order = build_order_object(parsed_result, order)

      render json: success_response('Account creation successful', id)
    end

    def cancel
      puts "Received order from AppDirect, requesting info..."

      parsed_result = read_event_data()
      render json: success_response('Account creation successful', '123')
    end

    def status
      puts "Received order from AppDirect, requesting info..."

      parsed_result = read_event_data()
      render json: success_response('Account creation successful', '123')
    end

    def notify
      puts "Received order from AppDirect, requesting info..."

      parsed_result = read_event_data()
      render json: success_response('Account creation successful', '123')
    end

    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def token
      params[:token]
    end

    def event_url
      params[:eventUrl]
    end

    def read_event_data
      raise "mandatory eventUrl parameter is not provided" if event_url.blank?

      puts "Got event URL #{event_url}"

      event_uri = URI.parse(event_url)

      site = "#{event_uri.scheme}://#{event_uri.host}"
      site += ":#{event_uri.port.to_s}" if (event_uri.port != 80) && (event_uri.port != 443)
      path = event_uri.path

      puts "Unsigned event URL #{site}#{path}"

      consumer = OAuth::Consumer.new(AppdirectIntegration.configuration.consumer_key.to_s,
                                     AppdirectIntegration.configuration.consumer_secret.to_s,
                                     { :site => site, :scheme => :query_string })
      req = consumer.create_signed_request(:get, path)
      full_path = "#{site}#{req.path}"

      puts "Requesting #{full_path}"

      result = RestClient.get full_path, :content_type => :json, :accept => :json

      puts "JSON Result: #{result.to_s}"

      parsed_result = ActiveSupport::JSON.decode(result.to_s)

      parsed_result
    end

    def update_order_object(parsed_result, order)
      Util.copy_known_fields(order, parsed_result)

      if !order_data["items"].nil? && order_data["items"].length > 0
        if order.respond_to?('order_items') && order.order_items.respond_to?('build')
          order_data["items"].each do |item|
            order_item = order.order_items.build()
            order_item.quantity = order_item["quantity"] if order_item.respond_to?('quantity=')
            order_item.unit = order_item["unit"] if order_item.respond_to?('unit=')
          end
        end
      end

      order.all_data = parsed_result.to_json if order.respond_to?('all_data=')

      order
    end

    def success_response(message, account_id)
      {success: true, message: message, accountIdentifier: account_id}.to_json #.to_xml(root: 'result')
    end

    def fault_response(message, error_code)
      {success: false, errorCode: error_code, message: message}.to_json #.to_xml(root: 'result')
    end
  end
end
