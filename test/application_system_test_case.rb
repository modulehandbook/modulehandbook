require "test_helper"

class SimpleApplicationSystemTestCase < ActionDispatch::SystemTestCase
  options = {}
  driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: options do |driver_option|
    driver_option.add_argument('--disable-search-engine-choice-screen')
  end
end
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase


  url = ENV.fetch('CHROME_URL', nil)
  if url
    puts "--------------------  using remote chrome! #{url}"
  else
    puts "--------------------  using local chrome!"
  end
  options = if url
    { browser: :remote, url: url }
  else
    { browser: :chrome }
  end

  driven_by :selenium, using: :headless_chrome, options: options

    # https://nicolasiensen.github.io/2022-03-11-running-rails-system-tests-with-docker/
  #if ENV['CHROME_URL']
  #  puts "using remote chrome! #{ENV['CHROME_URL']}"
  #  selenium_options = {
  #    browser: :remote,
  #    url: ENV['CHROME_URL'] }
  #  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: selenium_options
#
  #else 
  #  selenium_options = {}
  #  driven_by :selenium_headless, using: :chrome, screen_size: [1400, 1400], options: selenium_options
  #end

  
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
