require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @user = users(:reader)
    @admin = users(:one)
    @qa = users(:qa)
    # sign_in @admin
    # https://www.rubydoc.info/gems/devise/2.2.8#test-helpers
    sign_out :user # make sure not still signed in from other tests
  end

  test 'should not be signed in' do
    get root_path
    assert_redirected_to new_user_session_path
    follow_redirect!
    assert_response :success
    assert_nil @controller.current_user
  end

  test 'should get new' do
    get new_user_registration_url
    assert_response :success
    assert_nil @controller.current_user

  end

  test 'should get new with login' do
    sign_in @admin
    get new_user_registration_url
    assert_redirected_to root_url
  end

#  teardown do
#    sign_out @admin
#  end

end
