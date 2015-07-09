module AppdirectIntegration
  class AppdirectCallbacksController < ApplicationController
    def order
      puts "Received order from AppDirect"

      render xml: {success: true, message: 'Account creation successful', accountIdentifier: token}.to_xml(root: 'result')
    end

    def change
      puts "change"
      render :text => "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
<result>
    <success>true</success>
    <message>Account creation successful</message>
    <accountIdentifier>new-account-identifier</accountIdentifier>
</result>"
    end

    def cancel
      puts "cancel"
      render :text => "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
<result>
    <success>true</success>
    <message>Account creation successful</message>
    <accountIdentifier>new-account-identifier</accountIdentifier>
</result>"
    end

    def status
      puts "status"
      render :text => "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
<result>
    <success>true</success>
    <message>Account creation successful</message>
    <accountIdentifier>new-account-identifier</accountIdentifier>
</result>"
    end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def token
      params[:token]
    end

    def resp
    	hash = Hash.from_xml(response.parsed_response.gsub("\n", ""))
    end

    def success_response(account_id)

    end
  end
end