module AppdirectIntegration
  class AppdirectIntegrationGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)

    desc "Creates a AppdirectIntegration initializer and copy it to your application."

    def copy_initializer
      copy_file "appdirect.rb", "config/initializers/appdirect.rb"
    end

    def show_readme
      readme "README" if behavior == :invoke
    end

    def rails_4?
      Rails::VERSION::MAJOR == 4
    end
  end
end