module Decay
  module Enum
    def self.included(klass)
      klass.extend(ClassMethods)
    end

    module ClassMethods
      def enum(*)
      end
    end
  end
end
