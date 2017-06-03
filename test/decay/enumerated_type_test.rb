require "test_helper"

class EnumeratedTypeTest < TestCase
  def test_create_creates_class_with_named_values
    etc = Decay::EnumeratedType.create(:foo, :bar)

    assert_kind_of(Class, etc)
    assert_equal(%i[foo bar], etc.members.map(&:value))
  end

  def test_create_creates_class_with_set_values
    etc = Decay::EnumeratedType.create(foo: "foo", bar: "bar")

    assert_equal(%w[foo bar], etc.members.map(&:value))
  end

  def test_each
    etc = Decay::EnumeratedType.create(foo: "f", bar: "b")

    foo_happened = bar_happened = false

    etc.each do |key, value|
      if key == :foo && value.value == "f"
        foo_happened = true
      elsif key == :bar && value.value == "b"
        bar_happened = true
      end
    end

    assert(foo_happened)
    assert(bar_happened)

    assert_kind_of(Enumerable, etc.each)
  end

  def test_created_class_members_are_kind_of_itself
    etc = Decay::EnumeratedType.create(:foo, :bar)

    assert_kind_of(etc, etc.members.first)
  end

  def test_nil_enum
    foo_type = Decay::EnumeratedType.create(:foo, nil)
    bar_type = Decay::EnumeratedType.create(bar: "woah", nil => nil)
    baz_type = Decay::EnumeratedType.create(nil, baz: :qux)

    assert_equal([:foo, nil], foo_type.values)
    assert_equal([:bar, nil], bar_type.values)
    assert_equal([nil, :baz], baz_type.values)
  end

  def test_created_class_square_brackets
    etc = Decay::EnumeratedType.create(:foo, :bar)

    assert_kind_of(etc, etc[:foo])

    assert_raises(Decay::Error::UnknownKey) do
      etc[:baz]
    end
  end

  def test_frozen_class
    etc = Decay::EnumeratedType.create(:foo, :bar)

    assert_raises(Decay::Error::CantDefineEnumAtRuntime) do
      etc[:baz] = :baz
    end
  end

  def test_duplicate_enum_error
    assert_raises(Decay::Error::DuplicateEnum) do
      Decay::EnumeratedType.create(:foo, :foo)
    end
  end

  def test_case
    etc = Decay::EnumeratedType.create(:foo, :bar)

    etc[:foo].case
  end
end
