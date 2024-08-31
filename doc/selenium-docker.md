

# Running Selenium in Docker

see 
- [https://hub.docker.com/r/selenium/standalone-chrome](https://hub.docker.com/r/selenium/standalone-chrome)
- https://www.selenium.dev/documentation/webdriver/drivers/remote_webdriver/


https://www.selenium.dev/documentation/webdriver/drivers/remote_webdriver/

- ruby example:
https://github.com/SeleniumHQ/seleniumhq.github.io/blob/trunk/examples/ruby/spec/drivers/remote_webdriver_spec.rb#L20-L21

https://guides.rubyonrails.org/testing.html

https://github.com/SeleniumHQ/docker-selenium


CHROME_URL=http://localhost:4444/wd/hub bin/rails test:system


https://api.rubyonrails.org/classes/ActionDispatch/SystemTestCase.html



# fix backtrace error: 
        puts "---- error: #{error}"
          puts "---- message: #{message}"
          puts "---- backtrace: #{backtrace}"
          

code --goto /Users/kleinen/.rvm/gems/ruby-3.3.3@modhand/gems/selenium-webdriver-4.24.0/lib/selenium/webdriver/remote/response.rb:39

backtrace = backtrace.map{|h| "#{h['fileName']}:#{h['lineNumber']}" }
          