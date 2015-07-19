require 'rails/generators/named_base'

module AppdirectIntegration
  module Generators
    class AppdirectIntegrationGenerator < Rails::Generators::NamedBase
      include Rails::Generators::ResourceHelpers

      namespace "appdirect_integration"
      source_root File.expand_path("../templates", __FILE__)

      desc "Generates a model with the given NAME (if one does not exist) with appdirect_integration " <<
           "configuration plus a migration file."

      hook_for :orm

      # class_option :routes, desc: "Generate routes", type: :boolean, default: true

      # def add_appdirect_integration_routes
      #   appdirect_integration_route  = "appdirect_integration_for :#{plural_name}"
      #   appdirect_integration_route << %Q(, class_name: "#{class_name}") if class_name.include?("::")
      #   appdirect_integration_route << %Q(, skip: :all) unless options.routes?
      #   route appdirect_integration_route
      # end
    end
  end
end
