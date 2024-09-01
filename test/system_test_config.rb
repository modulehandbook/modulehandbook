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


class SystemTestConfig
    attr_accessor :driver, :driver_loc, 
                :driver_options,
                :selenium_host, :selenium_port, 
                :host_running_test,
                :capybara_run_server,
                :capybara_server_host,
                :capybara_app_host

    def initialize(driver)
          # browser and driver configuration
          @driver = driver # :chrome :headless_chrome :headless_firefox
          config_selenium
          detect_host_running_test
          detect_app_server
    end

    def config_selenium
        host = ENV.fetch('SELENIUM_REMOTE_HOST', nil)
        if host.nil?
            @driver_loc=:local
            @driver_options = {}
            @capybara_run_server = true
            
            puts "--------------------  using local browser!"
        else
          @selenium_host = host
          @driver_loc=:docker-selenium-standalone
          @selenium_port = ENV.fetch('SELENIUM_REMOTE_PORT', 4444)
          url = "http://#{selenium_host}:#{selenium_port}"
          puts "--------------------  using remote browser! #{url}"
          @driver_options = { browser: :remote, url: url }
          @capybara_run_server = false
        end
    end

    def detect_host_running_test
        docker_image = ENV.fetch('MODHAND_IMAGE', nil)
        @host_running_test = docker_image.nil? ? :local : :docker
    end

    def detect_app_server
        if !capybara_run_server
            if host_running_test == :local
                @capybara_server_host = "0.0.0.0"
                @capybara_app_host = "http://0.0.0.0:3000"
            else
                @capybara_server_host = selenium_host
                @capybara_app_host = "http://module-handbook:3000"
            end
        end
    end
end
