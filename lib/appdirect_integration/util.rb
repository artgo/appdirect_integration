require 'appdirect_integration/fields'

module AppdirectIntegration
  class Util

    def self.copy_known_fields(to, from)
      AppdirectIntegration::FIELDS.each do |field|
        if field[:path].present?
          Util.copy_path(to, field[:name], from, field[:path])
        end
      end
      to
    end

    # path here is the array with size >= 1
    def self.copy_path(to, field_name, from, path)
      val = Util.val_by_path(from, path)
      Util.copy_data(to, field_name, val)
    end

    # path here is the array with size >= 1
    def self.val_by_path(from, path)
      val = from
      path.each do |index|
        val = val[index]
        if val.nil?
          return val
        end
      end
      val
    end

    def self.copy_data(to, field_name, val)
      method_name = field_name + '='
      method_sym = method_name.to_sym
      if val.present? && to.respond_to?(method_name)
        to.send(method_sym, val)
      end
    end
  end
end
