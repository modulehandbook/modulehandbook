# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'
require 'simplecov'

# see .simplecov
SimpleCov.start 'rails'

require_relative '../config/environment'
require 'rails/test_help'

module ActionDispatch
  class IntegrationTest
    include Devise::Test::IntegrationHelpers
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...

    parallelize_teardown do
      # FileUtils.rm_rf(ActiveStorage::Blob.services.fetch(:test_fixtures).root)
    end
  end
end
