module Decay
  class Error < StandardError
    class UnknownKey < Error
    end

    class UndefinedCase < Error
    end

    class UnknownEnumValue < Error
    end

    class CantDefineEnumAtRuntime < Error
    end
  end
end
