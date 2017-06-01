require "test_helper"

class DecayTest < TestCase
  def test_standalone_usage
    et = Decay::EnumeratedType.new
    et[:phone] = "phone"
    et[:home] = "home"

    et.value = :phone

    assert_raises(Decay::Error) do
      et.case
        .when(:phone) {}
        .result
    end

    et.case
      .when(:phone) {}
      .when(:home) {}
      .result

    et.case
      .when(:phone) {}
      .else {}
      .result
  end

  class Meta
    include Decay::Enum

    enum model: %i[zoolander hansel]
  end

  def test_meta_usage
    meta = Meta.new

    meta.model = :zoolander

    assert_raises(Decay::Error) do
      meta.model.case
        .when(:zoolander) {}
        .result
    end

    meta.model.case
      .when(:zoolander) {}
      .when(:hansel) {}
      .result
  end
end
