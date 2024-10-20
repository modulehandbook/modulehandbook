# frozen_string_literal: true

require 'test_helper'

class UserFlowsIntegrationTest < ActionDispatch::IntegrationTest
  def setup
    #  puts self.class.ancestors
  end
  test 'should login' do
    @admin = u = users(:one)
    post('/users/sign_in', params: { 'user[email]' => u.email, 'user[password]' => 'geheim12',
                                     'user_email' => u.email, 'user_password' => 'geheim12' })
    follow_redirect!

    assert_equal ActionDispatch::TestResponse, @response.class
    assert_equal WelcomeController, @controller.class
    assert_equal @admin, @controller.current_user
  end
end
