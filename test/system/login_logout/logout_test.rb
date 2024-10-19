# frozen_string_literal: true

require 'application_system_test_case'

class LoginTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    system_test_login(@user.email, 'geheim12')
  end

  test 'logging out' do
    visit root_path
    assert_text :all, 'Logout'
    find(:link, 'Logout', visible: false).click
    assert_text 'Signed out successfully.'
  end
end
