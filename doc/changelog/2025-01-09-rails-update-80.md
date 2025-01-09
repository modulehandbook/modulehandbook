
# Rails update to 8.0

- https://rubygems.org/gems/rails/versions
- https://guides.rubyonrails.org/8_0_release_notes.html

## update to 7.1.5.1 December 10, 2024 (7 KB)

- new gemset modhand-72

### bundle install messages
##### I18n - irrelevant
Post-install message from i18n:
PSA: I18n will be dropping support for Ruby < 3.2 in the next major release (April 2025), due to Ruby's end of life for 3.1 and below (https://endoflife.date/ruby). Please upgrade to Ruby 3.2 or newer by April 2025 to continue using future versions of this gem.

##### Devise - already on latest version 4.9.4, ignoring
Post-install message from devise:

[DEVISE] Please review the [changelog] and [upgrade guide] for more info on Hotwire / Turbo integration.

  [changelog] https://github.com/heartcombo/devise/blob/main/CHANGELOG.md
  [upgrade guide] https://github.com/heartcombo/devise/wiki/How-To:-Upgrade-to-Devise-4.9.0-%5BHotwire-Turbo-integration%5D

#### Post-install message from rubyzip: (OK, abhängig von selenium)
RubyZip 3.0 is coming!
**********************

The public API of some Rubyzip classes has been modernized to use named
parameters for optional arguments. Please check your usage of the
following classes:
  * `Zip::File`
  * `Zip::Entry`
  * `Zip::InputStream`
  * `Zip::OutputStream`

Please ensure that your Gemfiles and .gemspecs are suitably restrictive
to avoid an unexpected breakage when 3.0 is released (e.g. ~> 2.3.0).
See https://github.com/rubyzip/rubyzip for details. The Changelog also
lists other enhancements and bugfixes that have been implemented since
version 2.3.0.

###### rubyzip: selenium webdriver
    selenium-webdriver (4.24.0)
      base64 (~> 0.2)
      logger (~> 1.4)
      rexml (~> 3.2, >= 3.2.5)
      rubyzip (>= 1.2.2, < 3.0)



## update to 7.2.2.1 December 10, 2024 (7 KB)
- uneventful

## update to 8.0.1 December 13, 2024 (7 KB)



### bin/rails test

ok  (barne.kleinen@htw-berlin.de @ rails_update_72✗)code/uas-module-handbook/module-handbook-2024>bin/rails test
DEPRECATION WARNING: `to_time` will always preserve the full timezone rather than offset of the receiver in Rails 8.1. To opt in to the new behavior, set `config.active_support.to_time_preserves_timezone = :zone`. (called from <top (required)> at /Users/kleinen/mine/current/code/uas-module-handbook/module-handbook-2024/config/environment.rb:23)
DEPRECATION WARNING: `to_time` will always preserve the full timezone rather than offset of the receiver in Rails 8.1. To opt in to the new behavior, set `config.active_support.to_time_preserves_timezone = :zone`. (called from <top (required)> at /Users/kleinen/mine/current/code/uas-module-handbook/module-handbook-2024/config/environment.rb:23)


# Running:


### update papertrail to 16.0

      PaperTrail 15.1.0 is not compatible with ActiveRecord 8.0.1. We allow PT
      contributors to install incompatible versions of ActiveRecord, and this
      warning can be silenced with an environment variable, but this is a bad
      idea for normal use. Please install a compatible version of ActiveRecord
      instead (>= 6.1, < 7.2). Please see the discussion in paper_trail/compatibility.rb
      for details.


### and...... the ASSET PIPELINE!!

export RAILS_MASTER_KEY=$(cat config/credentials/production.key)
RAILS_ENV=production ./bin/rails assets:precompile


.... did actually work. files in public are not delivered. Due to new thrust thing?!

### bin/rails app:update


What's next:
    Try Docker Debug for seamless, persistent debugging tools in any container or image → docker debug rails80-alpine-debug
    Learn more at https://docs.docker.com/go/debug-cli/
ok  (barne.kleinen@htw-berlin.de @ rails_update_72√)code/uas-module-handbook/module-handbook-2024>bin/rails app:update
    conflict  config/boot.rb
Overwrite /Users/kleinen/mine/current/code/uas-module-handbook/module-handbook-2024/config/boot.rb? (enter "h" for help) [Ynaqdhm] a
       force  config/boot.rb
       exist  config
    conflict  config/application.rb
       force  config/application.rb
    conflict  config/environment.rb
       force  config/environment.rb
    conflict  config/puma.rb
       force  config/puma.rb
       exist  config/environments
    conflict  config/environments/development.rb
       force  config/environments/development.rb
    conflict  config/environments/production.rb
       force  config/environments/production.rb
    conflict  config/environments/test.rb
       force  config/environments/test.rb
       exist  config/initializers
    conflict  config/initializers/assets.rb
       force  config/initializers/assets.rb
    conflict  config/initializers/content_security_policy.rb
       force  config/initializers/content_security_policy.rb
      create  config/initializers/cors.rb
    conflict  config/initializers/filter_parameter_logging.rb
       force  config/initializers/filter_parameter_logging.rb
    conflict  config/initializers/inflections.rb
       force  config/initializers/inflections.rb
      create  config/initializers/new_framework_defaults_8_0.rb
      remove  app/assets/stylesheets/application.css
      remove  config/initializers/cors.rb
       exist  bin
      create  bin/brakeman
      create  bin/dev
   identical  bin/rails
   identical  bin/rake
      create  bin/rubocop
    conflict  bin/setup
       force  bin/setup
       exist  public
      create  public/400.html
    conflict  public/404.html
       force  public/404.html
      create  public/406-unsupported-browser.html
    conflict  public/422.html
       force  public/422.html
    conflict  public/500.html
       force  public/500.html
      create  public/icon.png
      create  public/icon.svg
   identical  public/robots.txt
       rails  active_storage:update
Copied migration 20250109170523_add_service_name_to_active_storage_blobs.active_storage.rb from active_storage
Copied migration 20250109170524_create_active_storage_variant_records.active_storage.rb from active_storage
Copied migration 20250109170525_remove_not_null_on_active_storage_blobs_checksum.active_storage.rb from active_storage

After this, check Rails upgrade guide at https://guides.rubyonrails.org/upgrading_ruby_on_rails.html for more details about upgrading your app.


##
- mostly reverted config/environment.rb


#### notes/review

##### config/environments/production.rb

-  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
-  config.action_mailer.perform_caching = false

+  config.action_mailer.default_url_options = { host: "example.com" }

-  # Use a different logger for distributed setups.
-  # require 'syslog/logger'
-  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')
-
-  if ENV['RAILS_LOG_TO_STDOUT'].present?
-    logger           = ActiveSupport::Logger.new($stdout)
-    logger.formatter = config.log_formatter
-    config.logger    = ActiveSupport::TaggedLogging.new(logger)
-  end

+  # Enable DNS rebinding protection and other `Host` header attacks.
+  # config.hosts = [
+  #   "example.com",     # Allow requests from example.com
+  #   /.*\.example\.com/ # Allow requests from subdomains like `www.example.com`
+  # ]

##### config/environments/test.rb
-
-  config.log_level = :warn
-  config.hosts << '127.0.0.1'
-  config.hosts << '0.0.0.0'
-  config.hosts << '0.0.0.0:61402'
-  config.hosts << 'www.example.com'
-  config.hosts << '172.18.0.2'
-  config.hosts << 'selenium-standalone'
-  config.hosts << 'localhost'


##### config/initializers/assets.rb