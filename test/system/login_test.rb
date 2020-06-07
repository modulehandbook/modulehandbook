require "application_system_test_case"

class LoginTest < ApplicationSystemTestCase
  setup do
    @user = users(:one)
  end

  test "logging in" do
    visit new_user_session_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: 'geheim12'
    click_on "Log in"
    assert_text "Signed in successfully."
  end
end

