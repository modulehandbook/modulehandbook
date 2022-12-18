require 'test_helper'

# https://github.com/rubycdp/cuprite
require "capybara/cuprite"
#Capybara.javascript_driver = :cuprite
#Capybara.register_driver(:cuprite) do |app|
#  Capybara::Cuprite::Driver.new(app, window_size: [1200, 800])
## if you use Docker don't forget to pass no-sandbox option:
#  Capybara::Cuprite::Driver.new(app, browser_options: { 'no-sandbox': nil })
# end

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase

  #driven_by :selenium_headless #firefox
  driven_by :selenium_headless, using: :firefox
  # driven_by :cuprite
  # driven_by :cuprite, window_size: [1400, 1400], options:
  #  { js_errors: true }, browser_options: { 'no-sandbox': nil }

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

end
