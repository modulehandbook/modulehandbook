ENV['RAILS_ENV'] ||= 'test'

# see .simplecov
require 'simplecov'

require_relative '../config/environment'
require 'rails/test_help'


class ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
end

class ActiveSupport::TestCase
  fixtures :all
end
