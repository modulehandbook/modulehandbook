# frozen_string_literal: true

require 'test_helper'

class DeviseHelperTest < ActionDispatch::IntegrationTest
  # setup do
  #   @user = users(:reader)
  #   @admin = users(:one)
  #   @qa = users(:qa)
  #   sign_in @admin
  # end

  test 'should log in and log out' do
    @admin = users(:one)

    sign_in @admin
    get users_url
    # see https://api.rubyonrails.org/v7.0/classes/ActionDispatch/TestResponse.html
    # https://api.rubyonrails.org/v7.0/classes/ActionDispatch/Response.html
    assert_equal ActionDispatch::TestResponse, @response.class
    assert_equal UsersController, @controller.class
    assert_equal @admin, @controller.current_user

    sign_out @admin
    get courses_url
    assert_redirected_to new_user_session_path
    follow_redirect!

    # puts "controller: #{@controller.inspect}"
    assert_equal Devise::SessionsController, @controller.class
    assert_nil @controller.current_user
  end
end
