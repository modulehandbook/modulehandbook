require "test_helper"


# export SELENIUM_REMOTE_URL=http://selenium-standalone:4444

# SELENIUM_REMOTE_URL=http://localhost:4444
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase

  # used for local chrome
  HEADLESS=true 
  # used for docker 
  DRIVER = :firefox # :chrome

  host = ENV.fetch('SELENIUM_REMOTE_HOST', nil)
  
  if host
    selenium_port = ENV.fetch('SELENIUM_REMOTE_PORT', 4444)
    url = "http://#{host}:#{selenium_port}"
    # use chromium in docker container
    # to test this locally, run 
    #  SELENIUM_REMOTE_HOST=localhost bin/rails test:systems
    # or  
    #  SELENIUM_REMOTE_HOST=localhost bin/rails test test/system/smoke_test.rb
    puts "--------------------  using remote chrome! #{url}"
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
      Capybara.server_host = host
      Capybara.app_host = "http://module-handbook"
    else 
      puts "--------- using localhost"
      # settings for local
      Capybara.server_host = "0.0.0.0"
      Capybara.app_host = "http://0.0.0.0"
    end
    Capybara.configure do | config |
      
      config.run_server = false
      config.app_host = "http://0.0.0.0:3000"
      puts config.inspect
    end

  

  else
    puts "--------------------  using local chrome!"

    options =  {  }
    headless_or_not = HEADLESS ? :headless_chrome : :chrome 
    driven_by :selenium, using: headless_or_not, screen_size: [1400, 1400], options: options do |driver_option|
      driver_option.add_argument('--disable-search-engine-choice-screen')
    end
  end

  puts "---- Capybara.server_host #{Capybara.server_host}"
  puts "---- Capybara.app_host #{Capybara.app_host}"
   

 

    # https://nicolasiensen.github.io/2022-03-11-running-rails-system-tests-with-docker/
  #if ENV['SELENIUM_REMOTE_URL']
  #  puts "using remote chrome! #{ENV['SELENIUM_REMOTE_URL']}"
  #  selenium_options = {
  #    browser: :remote,
  #    url: ENV['SELENIUM_REMOTE_URL'] }
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
