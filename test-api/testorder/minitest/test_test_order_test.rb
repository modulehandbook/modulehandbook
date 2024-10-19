# frozen_string_literal: true

require 'minitest/autorun'
require_relative('global')
class TestOrder < Minitest::Test
  def setup; end

  def teardown
    TestLog.printlog ''
  end

  def test_1
    TestLog.log(1)
  end

  def test_2
    TestLog.log(2)
  end

  def test_3
    TestLog.log(3)
  end
end
