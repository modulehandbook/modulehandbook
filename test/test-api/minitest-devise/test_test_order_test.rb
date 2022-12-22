require 'test_helper'
require "minitest/autorun"
require_relative ("global")
class TestOrderDevise < ActionDispatch::IntegrationTest
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


  def test_1



  #  get root_url
  #  assert_redirected_to new_user_session_path
  #  follow_redirect!
    TestLog.log(11)


  end

  def test_2
    TestLog.log(12)
  #  sign_out :user
    sign_in(users(:qa))
    get courses_path
    assert_response :success
    puts "test signed in qa, #{@controller.current_user.email}"
  end

  def test_3
    TestLog.log(13)
  end

end
