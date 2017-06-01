module Decay
  class Case
    def initialize(enum_class, member)
      @enum_class = enum_class
      @member = member
      @whens = {}
    end

    def when(key, &block)
      if @enum_class.values.include?(key)
        @whens[key] = block
      else
        raise Error::UnknownKey
      end

      self
    end

    def else(&block)
      @enum_class.values.each do |key|
        if !@whens.key?(key)
          @whens[key] = block
        end
      end

      self
    end

    def result
      if @whens.keys.size != @enum_class.values.size
        raise Error::UnspecifiedKey
      end

      if @whens.key?(@member.value)
        @whens[@member.value].call(@member)
      else
        raise Error::UnknownEnumValue
      end
    end
  end
end
