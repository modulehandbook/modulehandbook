require 'test_helper'
require 'capybara/poltergeist'
require 'phantomjs'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium_headless #firefox
  # the comments tests dont work with chrome headless or poltergeist
  # driven_by :selenium_chrome_headless
end
