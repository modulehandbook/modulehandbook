require "minitest/autorun"
require_relative ("global")
require 'test_helper'

class TestOrder2 < ActiveSupport::TestCase

  def setup

  end

  def teardown
      puts TestLog.getlog.inspect
  end


  def test_1
    TestLog.log(11)

  end

  def test_2
    TestLog.log(12)
  end

  def test_3
    TestLog.log(13)
  end

end


class TestOrder3 < ActiveSupport::TestCase

  def setup

  end

  def teardown
      puts TestLog.getlog.inspect
  end


  def test_1
    TestLog.log(31)

  end

  def test_2
    TestLog.log(32)
  end

  def test_3
    TestLog.log(33)
  end

end
