require 'oauth'
require 'rest-client'
require 'appdirect_integration'
require 'uri'

module AppdirectIntegration
  class AppdirectCallbacksController < ApplicationController
    def order
      puts "Received order from AppDirect, requesting info..."

      parsed_result = read_event_data()

      order = build_order_object(parsed_result)

      if order.save
        render json: success_response('Account creation successful', order.id.to_s)
      else
        render json: fault_response('Error creating account', 'UNKNOWN_ERROR')
      end
    end

    def change
      puts "change"
      render json: success_response('Account creation successful', '123')
    end

    def cancel
      puts "cancel"
      render json: success_response('Account creation successful', '123')
    end

    def status
      puts "status"
      render json: success_response('Account creation successful', '123')
    end

    def notify
      puts "notify"
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

    def build_order_object(parsed_result)
      company = parsed_result["payload"]["company"]
      user = parsed_result["creator"]
      order_data = parsed_result["payload"]["order"]


      order = AppdirectIntegration.configuration.order_class.new

      order.company_uuid = company["uuid"] if order.respond_to?('company_uuid=')
      order.company_name = company["name"] if order.respond_to?('company_name=')
      order.company_email = company["email"] if order.respond_to?('company_email=')
      order.company_phone = company["phoneNumber"] if order.respond_to?('company_phone=')
      order.company_website = company["website"] if order.respond_to?('company_website=')
      order.company_country = company["country"] if order.respond_to?('company_country=')

      if !user.nil?
        order.user_uuid = user["uuid"] if order.respond_to?('user_uuid=')
        order.user_open_id = user["openId"] if order.respond_to?('user_open_id=')
        order.user_email = user["email"] if order.respond_to?('user_email=')
        order.user_first_name = user["firstName"] if order.respond_to?('user_first_name=')
        order.user_last_name = user["lastName"] if order.respond_to?('user_last_name=')
        order.user_language = user["language"] if order.respond_to?('user_language=')
        user_address = user["address"]
        if !user_address.nil?
          order.user_address_full_name = user_address["fullName"] if order.respond_to?('user_address_full_name=')
          order.user_address_company_name = user_address["companyName"] if order.respond_to?('user_address_company_name=')
          order.user_address_phone = user_address["phone"] if order.respond_to?('user_address_phone=')
          order.user_address_phone_extension = user_address["phoneExtension"] if order.respond_to?('user_address_phone_extension=')
          order.user_address_fax = user_address["fax"] if order.respond_to?('user_address_fax=')
          order.user_address_fax_extension = user_address["faxExtension"] if order.respond_to?('user_address_fax_extension=')
          order.user_address_street1 = user_address["street1"] if order.respond_to?('user_address_street1=')
          order.user_address_street2 = user_address["street2"] if order.respond_to?('user_address_street2=')
          order.user_address_city = user_address["city"] if order.respond_to?('user_address_city=')
          order.user_address_state = user_address["state"] if order.respond_to?('user_address_state=')
          order.user_address_zip = user_address["zip"] if order.respond_to?('user_address_zip=')
          order.user_address_country = user_address["country"] if order.respond_to?('user_address_country=')
          order.user_address_pobox = user_address["pobox"] if order.respond_to?('user_address_pobox=')
          order.user_address_pozip = user_address["pozip"] if order.respond_to?('user_address_pozip=')
        end
      end

      order.status = 'ACTIVE' if order.respond_to?('status=')
      order.edition = order_data["editionCode"] if order.respond_to?('edition=')
      order.marketplace_url = parsed_result["marketplace"]["baseUrl"] if order.respond_to?('marketplace_url=')
      order.pricing_duration = order_data["pricingDuration"] if order.respond_to?('pricing_duration=')
      if !order_data["items"].nil? && order_data["items"].length > 0
        if !order_data["items"][0].nil?
          order_item = order_data["items"][0]
          order.quantity = order_item["quantity"] if order.respond_to?('quantity=')
          order.unit = order_item["unit"] if order.respond_to?('unit=')
        end
        if order_data["items"].length > 1 && !order_data["items"][1].nil?
          order_item = order_data["items"][1]
          order.quantity2 = order_item["quantity"] if order.respond_to?('quantity2=')
          order.unit2 = order_item["unit"] if order.respond_to?('unit2=')
        end
        if order_data["items"].length > 2 && !order_data["items"][2].nil?
          order_item = order_data["items"][2]
          order.quantity3 = order_item["quantity"] if order.respond_to?('quantity3=')
          order.unit3 = order_item["unit"] if order.respond_to?('unit3=')
        end
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
