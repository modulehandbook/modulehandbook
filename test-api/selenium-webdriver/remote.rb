# frozen_string_literal: true

require 'selenium-webdriver'
# options = { browser: :remote, url: 'http://localhost:4444' }

# https://github.com/SeleniumHQ/selenium/wiki/Ruby-Bindings
# https://github.com/SeleniumHQ/docker-selenium?tab=readme-ov-file#quick-start

# use chromium!!!
# $ docker run --rm -it -p 4444:4444 -p 5900:5900 -p 7900:7900 --shm-size 2g selenium/standalone-chromium:latest

options = Selenium::WebDriver::Chrome::Options.new

# docker run -d -p 4444:4444 -p 7900:7900 --shm-size="2g" selenium/standalone-firefox:4.24.0-20240830
# docker run  -p 4444:4444 -p 7900:7900 --shm-size="2g" selenium/standalone-firefox:4.24.0-20240830
# options = Selenium::WebDriver::Firefox::Options.new

driver = Selenium::WebDriver.for :remote, options: options

driver.navigate.to 'http://module-handbook.f4.htw-berlin.de'
driver.quit

# element = driver.find_element(name: 'h3')
# element.assert_text 'Welcome'
# puts driver.title
