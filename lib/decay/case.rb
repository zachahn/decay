module Decay
  class Case
    def initialize(enums, key)
      @enums = enums
      @whens = {}
      @key = key
    end

    def when(key, &block)
      if @enums.keys.include?(key)
        @whens[key] = block
      else
        raise Error::UnknownKey
      end

      self
    end

    def else(&block)
      @enums.keys.each do |key|
        if !@whens.key?(key)
          @whens[key] = block
        end
      end

      self
    end

    def result
      if @whens.keys.size != @enums.keys.size
        raise Error::UnspecifiedKey
      end

      if @whens.key?(@key)
        @whens[@key].call(@enums[@key])
      else
        raise Error::UnknownEnumValue
      end
    end
  end
end
