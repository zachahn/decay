require "test_helper"

class MetaprogrammingTest < TestCase
  def test_duplicated_method
    klass = Class.new

    assert_raises(Decay::Error::EnumConflict) do
      klass.instance_eval do
        extend Decay::Enum

        define_method(:thought) {}

        enum thought: %i[haha lol plz stop metaprogramming]
      end
    end
  end

  def test_duplicated_scope
    klass = Class.new

    assert_raises(Decay::Error::EnumConflict) do
      klass.instance_eval do
        extend Decay::ActiveEnum

        define_singleton_method(:scope) { |*| }

        define_singleton_method(:haha) {}

        active_enum thought: %i[haha lol why are you still here]
      end
    end
  end
end
