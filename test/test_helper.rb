ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

# SimpleCov.start - this is done centrally in .simplecov
puts "require simplecov from test_helper"
require 'simplecov'


class ActionController::TestCase
  include Devise::Test::IntegrationHelpers
end

class ActiveSupport::TestCase
  # Run tests in parallel with specified workers
  # parallelize(workers: 1)
  # parallelize(workers: ENV.fetch("PARALLEL_WORKERS", :number_of_processors))

  # todo: still needed?
  include Devise::Test::IntegrationHelpers

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def system_test_login(email, password)
    visit new_user_session_path
    fill_in 'user_email', with: email
    fill_in 'user_password', with: password
    click_on 'Log in'
  end
end
