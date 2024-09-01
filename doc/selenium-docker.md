
# Running Selenium in Docker

export SELENIUM_REMOTE_HOST=localhost
export SELENIUM_REMOTE_PORT=4445

bin/rails test test/system/comments/comments_admin_test.rb:11




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
        

