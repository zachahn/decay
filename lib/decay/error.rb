module Decay
  class Error < StandardError
    class UnknownKey < Error
    end

    class UnspecifiedKey < Error
    end

    class UnknownEnumValue < Error
    end
  end
end
