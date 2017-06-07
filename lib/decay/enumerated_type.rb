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
            definition.each do |key|
              type[normalized(key)] = normalized(key)
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
          raise Error::CantDefineEnumAtRuntime, \
            "New values can only be created on Enum creation"
        elsif registry.key?(key)
          raise Error::DuplicateEnum, "Attempted to re-define `#{key.inspect}'"
        else
          registry[key] = new(key, value)
        end
      end

      def [](key)
        if registry.key?(key)
          registry[key]
        else
          valid_keys = registry.keys.map(&:inspect).map { |str| "`#{str}'" }
          raise Error::UnknownKey,
            "Attempted to search for unknown key `#{key.inspect}'. " \
            "Valid options are #{valid_keys.join(", ")}"
        end
      end

      def keys
        registry.keys
      end

      def key_for(value)
        if value.is_a?(EnumeratedType)
          registry.invert[value]
        else
          raw_value = registry.map { |k, v| [k, v.value] }.to_h
          raw_value.invert[value]
        end
      end

      def members
        registry.values
      end

      def freeze
        registry.freeze
        super
      end

      def each
        if !block_given?
          return enum_for(:each)
        end

        registry.each do |key, value|
          yield key, value
        end
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

    def initialize(key, value)
      @key = key
      @value = value
    end

    attr_reader :key
    attr_reader :value

    def case
      Case.new(self.class, self)
    end
  end
end
