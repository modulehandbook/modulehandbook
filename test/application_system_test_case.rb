require 'test_helper'
# require 'capybara/poltergeist'
# require 'phantomjs'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium_headless #firefox
  # the comments tests dont work with chrome headless or poltergeist
  # driven_by :selenium_chrome_headless

  # Add more helper methods to be used by all tests here...
  def system_test_login(email, password)
    visit new_user_session_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_on 'Log in'
  end

  def system_test_logout
    visit users_sign_out_path
  end
  def assert_logged_in
  end
  # assert_text 'Logged in as '+@user_writer.email
end
