module AppdirectIntegration
  class AppdirectCallbacksController < ApplicationController
    def order
      puts "order"
    end
    def change
      puts "change"
    end
    def cancel
      puts "cancel"
    end
    def status
      puts "status"
    end
  end
end