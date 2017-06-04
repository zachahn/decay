module Decay
  class ActiveEnumAttribute < ::ActiveModel::Type::Value
    def initialize(enum:)
      @enum = enum
    end

    # User input
    def cast(value)
      if value.is_a?(Decay::EnumeratedType)
        value
      elsif value.respond_to?(:to_sym)
        @enum[value.to_sym]
      else
        @enum[value]
      end
    end

    # Ruby => Database
    def serialize(value)
      if value.respond_to?(:value)
        value.value
      else
        value
      end
    end

    # Database => Ruby
    def deserialize(value)
      @enum[@enum.key_for(value)]
    end
  end
end
