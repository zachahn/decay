module Decay
  module Enum
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      # rubocop:disable Metrics/MethodLength
      def enum(**rules)
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
            enum = enumerated_type_class[new_value.to_sym]

            instance_variable_set("@#{enum_name}", enum)
          end
        end
      end
      # rubocop:enable Metrics/MethodLength
    end
  end
end
