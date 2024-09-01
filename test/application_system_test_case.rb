require "test_helper"

# system tests are test that access the rails app via
# the browser.
# thus, for the tests to run, the following services/processes are needed:
# - the process running the tests 
# - the app (rails) server
# - the browser & driver

# they can be executed using various configurations:

# test: local | docker
# app server: rack (started by capybara) | local | docker
# browser & driver:
#   - firefox or chrome
#   - headless or not
#   - local | docker


class ApplicationSystemTestCase < ActionDispatch::SystemTestCase

  HEADLESS = true
  # used for docker 
  DRIVER = :firefox # :chrome

  selenium_host = ENV.fetch('SELENIUM_REMOTE_HOST', nil)

  if selenium_host
    selenium_port = ENV.fetch('SELENIUM_REMOTE_PORT', 4444)
    url = "http://#{selenium_host}:#{selenium_port}"
    # use chromium in docker container
    # to test this locally, run 
    #  SELENIUM_REMOTE_HOST=localhost SELENIUM_REMOTE_PORT=4445 bin/rails test:system
    # or  
    #  SELENIUM_REMOTE_HOST=localhost SELENIUM_REMOTE_PORT=4445 bin/rails test test/system/smoke_test.rb
    puts "--------------------  using remote app server! #{url}"
    options = { browser: :remote, url: url }
    if DRIVER == :firefox
      driven_by :selenium, using: :firefox, screen_size: [1400, 1400]
    else
      driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400],
                options: options do |driver_option|
        driver_option.add_argument('--disable-search-engine-choice-screen')
      end
    end

    docker_image = ENV['MODHAND_IMAGE']
    if docker_image
      puts "--------- found docker image: #{docker_image}"
      # settings for docker
      Capybara.server_host = selenium_host
      Capybara.app_host = "http://module-handbook"
    else
      puts "--------- using localhost"
      # settings for local
      Capybara.server_host = "0.0.0.0"
      Capybara.app_host = "http://0.0.0.0"
    end
    Capybara.configure do |config|

      config.run_server = false
      config.app_host = "http://0.0.0.0:3000"
      puts config.inspect
    end

  else
    puts "--------------------  using local chrome!"

    options = {}
    headless_or_not = HEADLESS ? :headless_chrome : :chrome
    driven_by :selenium, using: :firefox, screen_size: [1400, 1400], options: options do |driver_option|
      driver_option.add_argument('--disable-search-engine-choice-screen')
    end
  end

  puts "---- Capybara.server_host #{Capybara.server_host}"
  puts "---- Capybara.app_host #{Capybara.app_host}"

  # https://nicolasiensen.github.io/2022-03-11-running-rails-system-tests-with-docker/
  # if ENV['SELENIUM_REMOTE_URL']
  #  puts "using remote chrome! #{ENV['SELENIUM_REMOTE_URL']}"
  #  selenium_options = {
  #    browser: :remote,
  #    url: ENV['SELENIUM_REMOTE_URL'] }
  #  driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400], options: selenium_options
  #
  # else
  #  selenium_options = {}
  #  driven_by :selenium_headless, using: :chrome, screen_size: [1400, 1400], options: selenium_options
  # end

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
