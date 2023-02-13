require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ModuleHandbook
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Used for Windows only
    # Since Windows does not support Unix Environment Variables: export VAR="VALUE"
    # An environment file is used instead while testing
    # http://railsapps.github.io/rails-environment-variables.html (Option Three)
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'local_env.yml')
      YAML.load(File.open(env_file))&.each do |key, value|
        ENV[key.to_s] = value
      end if File.exist?(env_file)
    end

    config.x.mh_hostname = ENV.fetch("DEVISE_EMAIL_HOSTNAME") { 'module-handbook.f4.htw-berlin.de' }
    config.x.mh_devise_email = ENV.fetch("DEVISE_EMAIL") { 'module-handbook@infrastructure.de' }
    config.active_record.use_yaml_unsafe_load = true


    #structure.sql instead of schema.rb - needed because custom SQL features (temporal tables) cant be stored in schema.rb
    config.active_record.schema_format = :sql

    # Makes reading date/time easier for user.
    # Rails change only, database still maintains UTC
    config.time_zone = 'Berlin'


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.active_record.legacy_connection_handling=false
    config.add_autoload_paths_to_load_path = false
    # see https://guides.rubyonrails.org/i18n.html
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]

    config.hosts << "module-handbook"
    config.hosts << "localhost"
    config.hosts << "module-handbook.f4.htw-berlin.de"
    config.hosts << "141.45.146.125"
    config.hosts << "module-handbook-staging.f4.htw-berlin.de"
    config.hosts << "141.45.146.126"

    # im nginx als schlichter 403 zu sehen:
    # [ActionDispatch::HostAuthorization::DefaultResponseApp] Blocked host: localhost
  end
end
