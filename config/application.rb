require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ModuleHandbook
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    config.x.mh_hostname = ENV.fetch("HOSTNAME") { 'module-handbook.herokuapp.com' }
    config.x.mh_devise_email = ENV.fetch("DEVISE_EMAIL") { 'module-handbook@infrastructure.de' }
    config.active_record.use_yaml_unsafe_load = true
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.hosts << "module-handbook"
  end
end
