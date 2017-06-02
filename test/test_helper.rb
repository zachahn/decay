$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "decay"

require "minitest/autorun"
require "pry-byebug"

class TestCase < Minitest::Test
end
