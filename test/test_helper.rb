$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "decay"
require "decay/rails"

require "minitest/autorun"
require "pry-byebug"
require "active_record"

class TestCase < Minitest::Test
end
