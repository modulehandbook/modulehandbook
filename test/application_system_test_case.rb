require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase

  # https://nicolasiensen.github.io/2022-03-11-running-rails-system-tests-with-docker/
  Capybara::save_path="./tmp"
  if ENV['CHROME_URL']
    selenium_options = {
      browser: :remote,
      url: ENV['CHROME_URL'] }
  else 
    selenium_options = {}
  end

  driven_by :selenium_headless, using: :chrome, screen_size: [1400, 1400], options: selenium_options

  def system_test_login(email, password)
    visit new_user_session_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_on 'Log in'
    assert_text 'Logged in'
  end

  def system_test_logout
    visit users_sign_out_path
  end

  def assert_logged_in
  end

end
