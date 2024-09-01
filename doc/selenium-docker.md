
# How to run system tests

    make start-test-environment


# Running Selenium in Docker

export SELENIUM_REMOTE_HOST=localhost
export SELENIUM_REMOTE_PORT=4477

bin/rails test test/system/comments/comments_admin_test.rb:11

## Test runs
## Sunday, 01.September 2024 19:32
## Firefox
### local/local : everything on local machine
Finished in 198.206022s, 0.2624 runs/s, 0.7265 assertions/s.
52 runs, 144 assertions, 2 failures, 2 errors, 4 skips
### local/docker : tests on local machine, app and browser in docker
### docker/docker : everything in docker


## Chrome
## local/local : everything on local machine
Finished in 32.479443s, 1.6010 runs/s, 4.7107 assertions/s.
52 runs, 153 assertions, 0 failures, 0 errors, 4 skips

## local/docker : tests on local machine, app and browser in docker
## docker/docker : everything in docker

## switch driver
  - set image in compose.override.yaml
  - activate appropiate DRIVER in test/application_system_test_case.rb

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
        

