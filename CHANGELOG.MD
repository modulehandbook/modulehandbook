
# Rails 7.1. upgrade - rails_upgrade_71
## Saturday, 13.July 2024 13:30

## Tests
[] 2.8 bin/rails test now runs test:prepare task
https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#bin-rails-test-now-runs-test-prepare-task
[] https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#actionview-testcase-rendered-no-longer-returns-a-string

[] https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#new-ways-to-handle-exceptions-in-controller-tests-integration-tests-and-system-tests

## devise


[DEVISE] Please review the [changelog] and [upgrade guide] for more info on Hotwire / Turbo integration.

  [changelog] https://github.com/heartcombo/devise/blob/main/CHANGELOG.md
  [upgrade guide] https://github.com/heartcombo/devise/wiki/How-To:-Upgrade-to-Devise-4.9.0-%5BHotwire-Turbo-integration%5D
  Post-install message from webdrivers:
Webdrivers gem update options
*****************************

Selenium itself now manages drivers by default: https://www.selenium.dev/documentation/selenium_manager
* If you are using Ruby 3+ — please update to Selenium 4.11+ and stop requiring this gem
* If you are using Ruby 2.6+ and Selenium 4.0+ — this version will work for now
* If you use Ruby < 2.6 or Selenium 3, a 6.0 version of this gem with additional support is planned

Restrict your gemfile to "webdrivers", "= 5.3.0" to stop seeing this message
## Warnings
[] DEPRECATION WARNING: Support for `config.active_support.cache_format_version = 6.1` has been deprecated and will be removed in Rails 7.2.
## Cleanup
[] remove comments with rails_upgrade_71: