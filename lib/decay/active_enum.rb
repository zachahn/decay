module Decay
  module ActiveEnum
    def active_enum(**rules)
      rules.each do |enum_name, enum_values|
        enumerated_type_class =
          if enum_values.is_a?(Hash)
            ::Decay::EnumeratedType.create(nil, **enum_values)
          else
            ::Decay::EnumeratedType.create(nil, *enum_values)
          end

        meta = Decay::Metaprogramming.new(
          class: self,
          enumerated_type: enumerated_type_class,
          enumerated_type_name: enum_name
        )

        meta.define_enumerated_type

        meta.define_active_record_bang_setters
        meta.define_active_record_question_getters

        meta.define_active_record_scopes
      end
    end
  end
end
