# frozen_string_literal: true

require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_url
    assert_response :success
  end
end

class WelcomeControllerLoggedInTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:one)
  end
  test 'should get index' do
    get root_url
    assert_response :success
  end
end
