require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ModuleHandbook
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.

    # rails_upgrade_71: try with # config/application.rb
    # config.load_defaults 7.0

    config.load_defaults 6.1
    config.active_support.cache_format_version = 7.0

    config.x.mh_hostname = ENV.fetch('DEVISE_EMAIL_HOSTNAME') { 'http://localhost:3000' }
    config.x.mh_devise_email = ENV.fetch('DEVISE_EMAIL') { 'module-handbook@infrastructure.de' }
    config.active_record.use_yaml_unsafe_load = true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # rails_upgrade_71: may need to be set to true? -> needs to be removed.
    # config.active_record.legacy_connection_handling=true
    config.add_autoload_paths_to_load_path = false
    # see https://guides.rubyonrails.org/i18n.html
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.hosts << 'module-handbook'
    config.hosts << 'localhost'
    config.hosts << 'module-handbook.f4.htw-berlin.de'
    config.hosts << 'module-handbook-staging.f4.htw-berlin.de'
    config.hosts << 'makesign.f4.htw-berlin.de'
    # config.hosts << "141.45.191.40"
    # config.hosts << "141.45.191.41"

    # im nginx als schlichter 403 zu sehen:
    # [ActionDispatch::HostAuthorization::DefaultResponseApp] Blocked host: localhost

    # rails_upgrade_71: may be necessary
    # https://guides.rubyonrails.org/upgrading_ruby_on_rails.html#sqlite3adapter-now-configured-to-be-used-in-a-strict-strings-mode
    # config.active_record.sqlite3_adapter_strict_strings_by_default = false
    begin
      config.version = File.read('./MH_VERSION').strip
    rescue StandardError
      config.version = 'unknown'
    end
  end
end
