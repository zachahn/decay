module Decay
  module Enum
    # rubocop:disable Metrics/MethodLength
    def enum(**rules)
      rules.each do |enum_name, enum_values|
        enumerated_type_class =
          if enum_values.is_a?(Hash)
            ::Decay::EnumeratedType.create(**enum_values)
          else
            ::Decay::EnumeratedType.create(*enum_values)
          end

        meta = Metaprogramming.new(
          class: self,
          enumerated_type: enumerated_type_class,
          enumerated_type_name: enum_name
        )

        meta.define_enumerated_type

        meta.define_getter
        meta.define_setter
      end
    end
    # rubocop:enable Metrics/MethodLength
  end
end
