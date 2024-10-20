# frozen_string_literal: true

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

# local/local : everything on local machine
# local/docker : tests on local machine, app and browser in docker
# docker/docker : everything in docker

class SystemTestConfig
  attr_reader   :driver, :driver_loc,
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
    if ENV.has_key?('SELENIUM_REMOTE_HOST')
      @selenium_host = ENV['SELENIUM_REMOTE_HOST']
      @driver_loc = :docker_selenium_standalone
      @selenium_port = ENV.fetch('SELENIUM_REMOTE_PORT', 4444)
      url = "http://#{@selenium_host}:#{@selenium_port}"
      @driver_options = { browser: :remote, url: url }
      @capybara_run_server = false
    else
      @driver_loc = :local
      @driver_options = {}
      @capybara_run_server = true
    end
  end

  def detect_host_running_test
    @host_running_test = ENV.has_key?('MODHAND_IMAGE') ? :local : :docker
  end

  def detect_app_server
    return if capybara_run_server

    @capybara_server_host = if host_running_test == :local
                              '0.0.0.0'
                            else
                              @selenium_host
                            end

    @capybara_app_host = if driver_loc == :local
                           'http://0.0.0.0:3000'
                         else # :docker_selenium_standalone
                           'http://module-handbook:3000'
                         end
  end

  def validate
    return if capybara_run_server

    browser_url = driver_options[:url]
    raise Error, "Remote browser url cannot be reached: #{browser_url}" unless HttpURLChecker(browser_url).available?
    return if check_host_availability(capybara_app_host)

    raise Error, "Rails app cannot be reached: #{capybara_app_host}"
  end

  class HttpURLChecker 
    def initialize(url_string)
      url = URI.parse(url_string)
      @host = url.host
      @port = url.port
      @path = url.path
    end
    def available?
      begin
        require 'net/http'
        req = Net::HTTP.new(@host, @port)
        req.request_head(@path)
      rescue StandardError
        # error occured, return false
        return false
      end
      # valid site
      true
    end
  end
  
end
