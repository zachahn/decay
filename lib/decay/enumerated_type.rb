module Decay
  class EnumeratedType
    class << self
      def create(*named_values, **key_value_pairs)
        type = Class.new(self)

        named_values.each do |value|
          type[value.to_sym] = value.to_sym
        end

        key_value_pairs.each do |key, value|
          type[key.to_sym] = value
        end

        type.freeze

        type
      end

      def []=(key, value)
        registry[key] = new(value)
      end

      def [](key)
        if registry.key?(key)
          registry[key]
        else
          raise Error::UnknownKey
        end
      end

      def values
        registry.keys
      end

      def members
        registry.values
      end

      def freeze
        registry.freeze
        super
      end

      private

      def registry
        @registry ||= {}
      end
    end

    def initialize(value)
      @value = value
    end

    attr_reader :value

    def case
      Case.new(self.class, self)
    end
  end
end
