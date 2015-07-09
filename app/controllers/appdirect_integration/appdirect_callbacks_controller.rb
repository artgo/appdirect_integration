module AppdirectIntegration
  class AppdirectCallbacksController < ApplicationController
    def order
      puts "order"
      render :text => "order"
    end

    def change
      puts "change"
      render :text => "change"
    end

    def cancel
      puts "cancel"
      render :text => "cancel"
    end

    def status
      puts "status"
      render :text => "status"
    end
  end
end