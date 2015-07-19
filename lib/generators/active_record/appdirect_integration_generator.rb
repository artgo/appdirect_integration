require 'rails/generators/active_record'
require 'generators/appdirect_integration/orm_helpers'
require 'appdirect_integration/fields'

module ActiveRecord
  module Generators
    class AppdirectIntegrationGenerator < ActiveRecord::Generators::Base
      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      include AppdirectIntegration::Generators::OrmHelpers
      source_root File.expand_path("../templates", __FILE__)

      def copy_appdirect_integration_migration
        if (behavior == :invoke && model_exists?) || (behavior == :revoke && migration_exists?(table_name))
          migration_template "migration_existing.rb", "db/migrate/add_appdirect_integration_to_#{table_name}.rb"
        else
          migration_template "migration.rb", "db/migrate/appdirect_integration_create_#{table_name}.rb"
        end
      end

      def generate_model
        invoke "active_record:model", [name], migration: false unless model_exists? && behavior == :invoke
      end

      def inject_appdirect_integration_content
        content = model_contents

        class_path = if namespaced?
          class_name.to_s.split("::")
        else
          [class_name]
        end

        indent_depth = class_path.size - 1
        content = content.split("\n").map { |line| "  " * indent_depth + line } .join("\n") << "\n"

        inject_into_class(model_path, class_path.last, content) if model_exists?
      end

      def migration_data
        data = "\n"
        AppdirectIntegration::FIELDS.each do |field|
          data += "      t.string :#{field[:name]}\n"
        end

        data
      end

      def ip_column
        # Padded with spaces so it aligns nicely with the rest of the columns.
        "%-8s" % (inet? ? "inet" : "string")
      end

      def inet?
        rails4? && postgresql?
      end

      def rails4?
        Rails.version.start_with? '4'
      end

      def postgresql?
        config = ActiveRecord::Base.configurations[Rails.env]
        config && config['adapter'] == 'postgresql'
      end
    end
  end
end
