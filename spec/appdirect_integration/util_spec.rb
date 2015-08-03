require 'spec_helper'
require 'appdirect_integration/util'

module TestTemps
  class Order
    attr_accessor :user_uuid, :user_open_id, :user_email, :user_first_name, :user_last_name,\
      :user_language, :user_address_full_name, :user_address_company_name, :user_address_phone,\
      :user_address_phone_extension, :user_address_fax, :user_address_fax_extension, :user_address_street1,\
      :user_address_street2, :user_address_city, :user_address_state, :user_address_zip,\
      :user_address_country, :user_address_pobox, :user_address_pozip, :company_uuid, :company_name,\
      :company_email, :company_phone, :company_website, :company_country, :status, :edition,\
      :pricing_duration, :marketplace_url, :quantity, :unit, :quantity2, :unit2, :quantity3,\
      :unit3, :all_data
  end
end

describe AppdirectIntegration::Util do
  describe 'copy_known_fields' do
    before do
      test_response = <<-STR
{
   "type":"SUBSCRIPTION_ORDER",
   "marketplace":{
      "partner":"APPDIRECT",
      "baseUrl":"http://localhost:8080"
   },
   "applicationUuid":null,
   "flag":"DEVELOPMENT",
   "creator":{
      "uuid":"9ea8babf-f161-4470-a98c-0b5b07c06a4d",
      "openId":"http://localhost:8080/openid/id/9ea8babf-f161-4470-a98c-0b5b07c06a4d",
      "email":"admin@a.com",
      "firstName":"FirstName",
      "lastName":"LastName",
      "language":"en",
      "address":null,
      "attributes":null
   },
   "payload":{
      "user":null,
      "company":{
         "uuid":"1d12b0bf-5d09-48f5-bf33-ba503d20fd7b",
         "externalId":null,
         "name":"A Company",
         "email":"some@email.com",
         "phoneNumber":"877-404-2777",
         "website":"acompany.com",
         "country":"US"
      },
      "account":null,
      "addonInstance":null,
      "addonBinding":null,
      "order":{
         "editionCode":"EDITION_CODE",
         "addonOfferingCode":null,
         "pricingDuration":"MONTHLY",
         "items":[
            {
               "unit":"PIECE",
               "quantity":11
            }
         ]
      },
      "notice":null,
      "configuration":{

      }
   },
   "returnUrl":null,
   "links":[

   ]
}
STR
      @parsed_result = ActiveSupport::JSON.decode(test_response)
      @obj = TestTemps::Order.new
      AppdirectIntegration::Util.copy_known_fields(@obj, @parsed_result)
    end

    it 'sets quantity' do
      expect(@obj.quantity).to eq 11
    end

    it 'sets unit' do
      expect(@obj.unit).to eq 'PIECE'
    end

    it 'sets user uuid' do
      expect(@obj.user_uuid).to eq "9ea8babf-f161-4470-a98c-0b5b07c06a4d"
    end

    it 'sets user email' do
      expect(@obj.user_email).to eq "admin@a.com"
    end

    it 'sets user first name' do
      expect(@obj.user_first_name).to eq "FirstName"
    end

    it 'sets user last name' do
      expect(@obj.user_last_name).to eq "LastName"
    end

    it 'sets company uuid' do
      expect(@obj.company_uuid).to eq "1d12b0bf-5d09-48f5-bf33-ba503d20fd7b"
    end

    it 'sets company email' do
      expect(@obj.company_email).to eq "some@email.com"
    end

    it 'sets company name' do
      expect(@obj.company_name).to eq "A Company"
    end

    it 'sets company phone' do
      expect(@obj.company_phone).to eq "877-404-2777"
    end

    it 'sets company website' do
      expect(@obj.company_website).to eq "acompany.com"
    end

    it 'sets edition' do
      expect(@obj.edition).to eq "EDITION_CODE"
    end

    it 'sets pricing duration' do
      expect(@obj.pricing_duration).to eq "MONTHLY"
    end
  end
end

