ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'

# see .simplecov
SimpleCov.start 'rails'

require_relative '../config/environment'
require 'rails/test_help'



class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end

class ActiveSupport::TestCase
  fixtures :all
end
