
# How to run system tests

    make start-test-environment


# Running Selenium in Docker

export SELENIUM_REMOTE_HOST=localhost
export SELENIUM_REMOTE_PORT=4477

bin/rails test test/system/comments/comments_admin_test.rb:11

## Test runs
## Sunday, 01.September 2024 19:32
## Firefox
### local/local : tests and browser on local machine
Finished in 63.374802s, 0.8205 runs/s, 2.1775 assertions/s.
52 runs, 138 assertions, 0 failures, 4 errors, 4 skips
### local/docker : tests on local machine, browser in docker
Finished in 400.201054s, 0.1299 runs/s, 0.2974 assertions/s.
52 runs, 119 assertions, 5 failures, 13 errors, 2 skips

### docker/docker : everything in docker


## Chrome
## local/local : everything on local machine

Finished in 39.416731s, 1.3192 runs/s, 3.5011 assertions/s.
52 runs, 138 assertions, 0 failures, 4 errors, 4 skips

## local/docker : tests on local machine, app and browser in docker
does not work.
## docker/docker : everything in docker

## switch driver
  - set image in compose.override.yaml
  - activate appropiate DRIVER in test/application_system_test_case.rb

## chromium
https://github.com/SeleniumHQ/docker-selenium

# sort
 test/application_system_test_case.rb

see 
- [https://hub.docker.com/r/selenium/standalone-chrome](https://hub.docker.com/r/selenium/standalone-chrome)
- https://www.selenium.dev/documentation/webdriver/drivers/remote_webdriver/


https://www.selenium.dev/documentation/webdriver/drivers/remote_webdriver/

- ruby example:
https://github.com/SeleniumHQ/seleniumhq.github.io/blob/trunk/examples/ruby/spec/drivers/remote_webdriver_spec.rb#L20-L21

https://guides.rubyonrails.org/testing.html

https://github.com/SeleniumHQ/docker-selenium


SELENIUM_REMOTE_URL=http://localhost:4444/wd/hub bin/rails test:system


https://api.rubyonrails.org/classes/ActionDispatch/SystemTestCase.html



# fix backtrace error: 
        puts "---- error: #{error}"
          puts "---- message: #{message}"
          puts "---- backtrace: #{backtrace}"
          

code --goto /Users/kleinen/.rvm/gems/ruby-3.3.3@modhand/gems/selenium-webdriver-4.24.0/lib/selenium/webdriver/remote/response.rb:39

backtrace = backtrace.map{|h| "#{h['fileName']}:#{h['lineNumber']}" }
          
## improved

/Users/kleinen/.rvm/gems/ruby-3.3.3@modhand/gems/selenium-webdriver-4.24.0/lib/selenium/webdriver/remote/response.rb

puts " ------ backtrace class:"
          puts backtrace.class
          puts backtrace
          if !backtrace.nil? && backtrace.class == Array && backtrace[0].class == Hash
            backtrace = backtrace.map{|h| "#{h['fileName']}:#{h['lineNumber']}" } # if 
          end
        

