require "test_helper"
require "capybara/poltergeist"
require 'phantomjs'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  # driven_by :selenium, using: :chrome, screen_size: [1400, 1400]
  # driven_by :selenium, using: :headless_chrome, screen_size: [1400, 1400]
  driven_by :poltergeist, screen_size: [1400, 1400],
    options:  { js_errors: false,
                phantomjs: Phantomjs.path }
end

# webdrivers
