# frozen_string_literal: true

require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  test 'can see the welcome page' do
    get '/'
    assert_select 'h3', /Welcome to the.*/
  end

  def assert_status(expected_status)
    assert_equal last_response.status, Rack::Utils.status_code(expected_status)
  end

  test 'login not existent' do
    users(:qa)
    post '/users/sign_in',
         params: { user: { email: 'notthere@mail.de', password: 'geheim12' } }
    assert_response :unprocessable_entity
  end

  test 'login wrong password' do
    user = users(:qa)
    post '/users/sign_in',
         params: { user: { email: user.email, password: 'not_geheim12' } }
    assert_response :unprocessable_entity
  end

  test 'login' do
    user = users(:qa)
    post '/users/sign_in',
         params: { user: { email: user.email, password: 'geheim12' } }
    assert_response :redirect
    follow_redirect!
    assert_select 'p', 'Signed in successfully.'
  end
end
