# frozen_string_literal: true

require 'test_helper'
require 'minitest/autorun'
require_relative('../minitest/global')
class TestOrderDevise < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:one)
    @user2 = users(:reader)
    sign_in(@admin)
    get courses_path
    assert_response :success
  end

  def teardown
    TestLog.printlog(@controller.current_user.email)
  end

  test 'should get index' do
    get course_programs_url
    assert_response :success
  end

  def test_1_3rdpartyapi
    #  get root_url
    #  assert_redirected_to new_user_session_path
    #  follow_redirect!
    TestLog.log(11)
  end

  def test_2_3rdpartyapi
    TestLog.log(12)
    #  sign_out :user
    sign_in(users(:qa))
    get courses_path
    assert_response :success
    TestLog.print("test signed in qa, #{@controller.current_user.email}")
  end

  def test_3_3rdpartyapi
    TestLog.log(13)
  end
end
