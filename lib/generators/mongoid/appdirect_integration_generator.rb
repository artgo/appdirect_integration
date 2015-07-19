require 'rails/generators/named_base'
require 'generators/appdirect_integration/orm_helpers'
require 'appdirect_integration/fields'

module Mongoid
  module Generators
    class AppdirectIntegrationGenerator < Rails::Generators::NamedBase
      include AppdirectIntegration::Generators::OrmHelpers

      def generate_model
        invoke "mongoid:model", [name] unless model_exists? && behavior == :invoke
      end

      def inject_field_types
        inject_into_file model_path, migration_data, after: "include Mongoid::Document\n" if model_exists?
      end

      def inject_appdirect_integration_content
        inject_into_file model_path, model_contents, after: "include Mongoid::Document\n" if model_exists?
      end

      def migration_data
        data = "\n"
        AppdirectIntegration::FIELDS.each do |field|
          data += "  field :#{field[:name]}, type: String\n"
        end

        data
      end
    end
  end
end
