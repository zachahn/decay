module Decay
  class EnumeratedType
    class << self
      def create(*definitions)
        type = Class.new(self)

        definitions.each do |definition|
          if definition.respond_to?(:keys)
            definition.each do |key, value|
              type[normalized(key)] = value
            end
          elsif definition.respond_to?(:each)
            definition.each do |value|
              type[normalized(value)] = normalized(value)
            end
          else
            type[normalized(definition)] = normalized(definition)
          end
        end

        type.freeze

        type
      end

      def []=(key, value)
        if registry.frozen?
          raise Error::CantDefineEnumAtRuntime
        else
          registry[key] = new(value)
        end
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

      def normalized(value)
        if value.respond_to?(:to_sym)
          value.to_sym
        else
          value
        end
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
