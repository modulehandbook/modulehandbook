# frozen_string_literal: true

require 'application_system_test_case'

class ExploreTestEnvironmentTest < ApplicationSystemTestCase
  setup do
    @user_editor = users(:editor)
    @user_writer = users(:writer)
    @user = @user_writer
    system_test_login(@user.email, 'geheim12')
  end

  teardown do
    system_test_logout
  end

  #  test 'test_order' do
  #    puts "ActiveSupport::TestCase.test_order #{ActiveSupport::TestCase.test_order}"
  #    puts page
  #  end
end
