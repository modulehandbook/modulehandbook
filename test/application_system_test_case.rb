require "test_helper"
require "system_test_config"


 # to test this locally, run 
    #  SELENIUM_REMOTE_HOST=localhost SELENIUM_REMOTE_PORT=4445 bin/rails test:system
    # or  
    #  SELENIUM_REMOTE_HOST=localhost SELENIUM_REMOTE_PORT=4445 bin/rails test test/system/smoke_test.rb
   ## export SELENIUM_REMOTE_HOST=module-handbook
   ## export SELENIUM_REMOTE_HOST=localhost

   module ActiveSupport
    class TestCase
      # no parallelization for selenium...
      parallelize(workers: 1)
    end
  end
  
class ApplicationSystemTestCase < ActionDispatch::SystemTestCase

  # :chrome :headless_chrome 
  # :firefox :headless_firefox
     
  config = SystemTestConfig.new :headless_firefox

  driven_by :selenium, using: config.driver, 
    screen_size: [1400, 1400],
    options: config.driver_options do |driver_option|
        driver_option.add_argument('--disable-search-engine-choice-screen')
    end
    
  
    Capybara.configure do |capybara_config|
      if config.capybara_run_server
        capybara_config.run_server = true
      else
        capybara_config.run_server = false
        capybara_config.app_host = config.capybara_app_host
        capybara_config.server_host = config.capybara_server_host
        server_available = config.check_host_availability(config.capybara_app_host)
      end
    end
  

  puts "---------- "
  puts "---------- config "
  puts "#{config.inspect}"
  puts "---------- "
  puts "---- Capybara.server_host #{Capybara.server_host}"
  puts "---- Capybara.app_host #{Capybara.app_host}"



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
