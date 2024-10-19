require 'application_system_test_case'

class LoginTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
    system_test_logout
  end

  test 'logging in' do
    visit users_sign_out_path
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: 'geheim12'
    click_on 'Log in'
    assert_text 'Signed in successfully.'
  end
end
