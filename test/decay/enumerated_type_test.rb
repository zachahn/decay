require "test_helper"

class EnumeratedTypeTest < TestCase
  def test_value_must_be_defined
    et = Decay::EnumeratedType.new
    et[:foo] = :foo

    assert_raises(Decay::Error::UnknownEnumValue) do
      et.case
        .when(:foo) {}
        .result
    end
  end

  def test_value_must_be_an_enum
    et = Decay::EnumeratedType.new
    et[:foo] = :foo

    assert_raises(Decay::Error::UnknownEnumValue) do
      et.value = :bar
    end
  end
end
