# frozen_string_literal: true

# Load the Rails application.
require_relative 'application'

# Rails.application.configure do

ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.delivery_method = :smtp

unless Rails.application.credentials.devise.nil?
  ActionMailer::Base.smtp_settings = {
    port: Rails.application.credentials.devise.smtp_port,
    address: Rails.application.credentials.devise.smtp_server,
    user_name: Rails.application.credentials.devise.smtp_login,
    password: Rails.application.credentials.devise.smtp_password,
    authentication: :login,
    enable_starttls_auto: true
  }
end

# Initialize the Rails application.
Rails.application.initialize!
