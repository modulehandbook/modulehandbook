require 'test_helper'

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  Capybara::save_path="./tmp"
  driven_by :selenium_headless #firefox
  # the comments tests dont work with chrome headless or poltergeist
  # driven_by :selenium_chrome_headless
end
