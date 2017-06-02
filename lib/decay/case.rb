module Decay
  class Case
    def initialize(enum_class, member)
      @enum_class = enum_class
      @member = member
      @whens = {}
    end

    def when(value, &block)
      if @enum_class.values.include?(value)
        @whens[value] = block
      else
        raise Error::UnknownKey
      end

      self
    end

    def else(&block)
      @enum_class.values.each do |value|
        if !@whens.key?(value)
          @whens[value] = block
        end
      end

      self
    end

    def result
      if @whens.keys.size != @enum_class.values.size
        raise Error::UndefinedCase
      end

      if @whens.key?(@member.value)
        @whens[@member.value].call(@member)
      else
        raise Error::UnknownEnumValue
      end
    end
  end
end
