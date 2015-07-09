module AppdirectIntegration
  class AppdirectCallbacksController < ApplicationController
    def order
      puts "order"
      render :text => "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>
<result>
    <success>true</success>
    <message>Account creation successful</message>
    <accountIdentifier>new-account-identifier</accountIdentifier>
</result>"
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
  end
end