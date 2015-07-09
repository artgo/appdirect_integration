require 'rails/generators/base'

module AppdirectIntegration
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)

      desc "Creates a AppdirectIntegration initializer and copy it to your application."
      class_option :orm

      def copy_initializer
        template "appdirect.rb", "config/initializers/appdirect.rb"
      end

      def show_readme
        readme "README" if behavior == :invoke
      end

      def rails_4?
        Rails::VERSION::MAJOR == 4
      end
    end
	end
end