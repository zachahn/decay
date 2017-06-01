module Decay
  class EnumeratedType
    def initialize
      @registry = {}
      @value = nil
    end

    attr_reader :value

    def value=(new_value)
      if @registry.key?(new_value)
        @value = new_value
      else
        raise Error::UnknownEnumValue
      end
    end

    def []=(key, value)
      @registry[key] = value
    end

    def case
      Case.new(@registry, @value)
    end
  end
end
