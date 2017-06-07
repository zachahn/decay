module Decay
  class Case
    def initialize(enum_class, member)
      @enum_class = enum_class
      @member = member
      @whens = {}
    end

    def when(key, &block)
      if @enum_class.keys.include?(key)
        @whens[key] = block
      else
        raise Error::UnknownKey
      end

      self
    end

    def else(&block)
      @enum_class.keys.each do |key|
        if !@whens.key?(key)
          @whens[key] = block
        end
      end

      self
    end

    def result
      if @whens.keys.size != @enum_class.keys.size
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
