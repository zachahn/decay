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
        raise_unknown_key
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

      if @whens.key?(@member.key)
        @whens[@member.key].call(@member)
      else
        raise Error::UnknownEnumValue
      end
    end

    def raise_unknown_key
      valid_keys = @enum_class.keys.map(&:inspect).map { |str| "`#{str}'"}
      raise Error::UnknownKey,
        "Attempted to search for unknown key `#{@member.value.inspect}'. " \
        "Valid options are #{valid_keys.join(", ")}"
    end
  end
end
