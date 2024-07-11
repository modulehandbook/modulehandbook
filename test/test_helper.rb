ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start 'rails'

require_relative '../config/environment'
require 'rails/test_help'

# see .simplecov


class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end

class ActiveSupport::TestCase
  fixtures :all
end
