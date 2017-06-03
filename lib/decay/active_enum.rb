module Decay
  module ActiveEnum
    def active_enum(**rules)
      rules.each do |enum_name, enum_values|
        enumerated_type_class =
          if enum_values.is_a?(Hash)
            ::Decay::EnumeratedType.create(**enum_values)
          else
            ::Decay::EnumeratedType.create(*enum_values)
          end

        const_set(enum_name.to_s.upcase, enumerated_type_class)

        define_method(enum_name) do
          instance_variable_get("@#{enum_name}")
        end

        define_method("#{enum_name}=") do |new_value|
          value =
            if new_value.respond_to?(:to_sym)
              new_value.to_sym
            else
              new_value
            end

          enum = enumerated_type_class[value]

          instance_variable_set("@#{enum_name}", enum)
        end

        enumerated_type_class.each do |key, value|
          define_method("#{key}!") do
            instance_variable_set("@#{enum_name}", value)
          end

          define_method("#{key}?") do
            instance_variable_get("@#{enum_name}") == value
          end

          if enum_name
            scope key, -> { where(enum_name => value.value) }
          end
        end
      end
    end
  end
end
