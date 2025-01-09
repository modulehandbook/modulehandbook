
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
