require 'oauth'
require 'rest-client'
require 'uri'
require 'appdirect_integration'
require 'appdirect_integration/util'

module AppdirectIntegration
  class AppdirectCallbacksController < ApplicationController
    def order
      puts "Received order event from AppDirect, requesting info..."

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
      respond_to_event('change')
    end

    def cancel
      respond_to_event('cancel', 'CANCELLED')
    end

    def notify
      respond_to_event('notify')
    end

    private
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

    def respond_to_event(name, new_status)
      puts "Received #{name} event from AppDirect, requesting info..."

      parsed_result = read_event_data()

      id = parsed_result["payload"]["account"]["accountIdentifier"]

      order = AppdirectIntegration.configuration.order_class.find(id)
      order = update_order_object(parsed_result, order)

      if new_status.present? && order.respond_to?('status=')
        order.status = new_status
      end

      if order.save
        render json: success_response("Event #{name} processed successfuly", id)
      else
        render json: fault_response('Error updating account', 'UNKNOWN_ERROR')
      end
    end

    def build_order_object(parsed_result, order)
      Util.copy_known_fields(order, parsed_result)

      if parsed_result["payload"].present?
        order_data = parsed_result["payload"]["order"]

        if order_data.present? && order_data["items"].present? && order_data["items"].length > 0
          if order.respond_to?('order_items') && order.order_items.respond_to?('build')
            order_data["items"].each do |item|
              order_item = order.order_items.build()
              order_item.quantity = item["quantity"] if order_item.respond_to?('quantity=')
              order_item.unit = item["unit"] if order_item.respond_to?('unit=')
            end
          end
        end
      end

      order.all_data = parsed_result.to_json if order.respond_to?('all_data=')

      order
    end

    def update_order_object(parsed_result, order)
      Util.copy_known_fields(order, parsed_result)

      if parsed_result["payload"].present?
        order_data = parsed_result["payload"]["order"]

        if order_data.present? && order_data["items"].present? && order_data["items"].length > 0
          if order.respond_to?('order_items') && order.order_items.respond_to?('build')
            order_data["items"].each do |item|
              order_item = order.order_items.find_or_create_by(unit: item["unit"])
              order_item.quantity = item["quantity"] if order_item.respond_to?('quantity=')
            end
          end
        end
      end

      order
    end

    def success_response(message, account_id)
      {success: true, message: message, accountIdentifier: account_id}.to_json
    end

    def fault_response(message, error_code)
      {success: false, errorCode: error_code, message: message}.to_json
    end
  end
end
