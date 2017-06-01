module Decay
  class EnumeratedType
    def initialize
      @registry = {}
      @value = nil
    end

    attr_accessor :value

    def []=(key, value)
      @registry[key] = value
    end

    def case
      Case.new(@registry, @value)
    end
  end
end
