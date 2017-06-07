require "test_helper"

class EnumTest < TestCase
  class Misc
    extend Decay::Enum

    enum green_eggs: %i[fox box house mouse] + [nil]

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

  def test_set_nil
    misc = Misc.new

    misc.green_eggs = nil

    assert_nil(misc.green_eggs.value)
  end

  def test_case
    misc = Misc.new
    misc.villain = :doctor_evil

    result =
      misc.villain.case
        .when(:mugatu) { "I invented the piano necktie" }
        .when(:doctor_evil) { "One million dollars!" }
        .when(:kim_jong_un) { "Sometimes I feel like a plastic bag" }
        .result

    assert_equal("One million dollars!", result)
  end
end
