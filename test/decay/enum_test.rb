require "test_helper"

class EnumTest < TestCase
  class Misc
    include Decay::Enum

    enum green_eggs: %i[fox box house mouse]

    enum villain: \
      {
        mugatu: "Jacobim Mugatu",
        doctor_evil: "Doctor Evil",
        kim_jong_un: "Baby you're a firework",
      }
  end

  def test_creation_of_enum_classes
    assert_includes(Misc::GREEN_EGGS.ancestors, Decay::EnumeratedType)
    assert_includes(Misc::VILLAIN.ancestors, Decay::EnumeratedType)
  end

  def test_get_before_set_is_nil
    misc = Misc.new

    assert_nil(misc.green_eggs)
    assert_nil(misc.villain)
  end

  def test_get_after_set
    misc = Misc.new

    misc.green_eggs = :fox
    misc.green_eggs = :box
    misc.green_eggs = :house
    misc.green_eggs = :mouse
    assert_kind_of(Misc::GREEN_EGGS, misc.green_eggs)

    misc.villain = :mugatu
    misc.villain = :doctor_evil
    misc.villain = :kim_jong_un
    assert_kind_of(Misc::VILLAIN, misc.villain)
  end
end
