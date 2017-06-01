require "test_helper"

class DecayTest < TestCase
  def test_standalone_usage
    et_class = Decay::EnumeratedType.create(:phone, :home)

    value = et_class[:phone]

    assert_raises(Decay::Error) do
      value.case
        .when(:phone) {}
        .result
    end

    value.case
      .when(:phone) {}
      .when(:home) {}
      .result

    value.case
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
