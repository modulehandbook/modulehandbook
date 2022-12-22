require "minitest/autorun"
require_relative ("global")
require 'test_helper'

class TestOrderDevise2 < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:one)
    @user2 = users(:reader)
    sign_in(@admin)
    get courses_path
    assert_response :success
  end

  def teardown
      puts TestLog.getlog.inspect
      puts @controller.current_user.email
       puts "----------------"
  end

  def test_1_3rdpartyapi
    TestLog.log(21)

  end

  def test_2_3rdpartyapi
    TestLog.log(22)
  end

  def test_3_3rdpartyapi
    TestLog.log(23)
  end

end


class TestOrderDevise3 < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:one)
    @user2 = users(:reader)
    sign_in(@user2)
    get courses_path
    assert_response :success
  end

  def teardown
      puts TestLog.getlog.inspect
      puts @controller.current_user.email
            puts "----------------"
  end


  def test_1_3rdpartyapi
    TestLog.log(31)

  end

  def test_2_3rdpartyapi
    TestLog.log(32)
  end

  def test_3_3rdpartyapi
    TestLog.log(33)
  end

end
