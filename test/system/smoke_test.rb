# frozen_string_literal: true

require 'application_system_test_case'

# class SimpleApplicationSystemTestCase < ActionDispatch::SystemTestCase
#   options = {}
#   driven_by :selenium, using: :chrome, screen_size: [1400, 1400], options: options do |driver_option|
#     driver_option.add_argument('--disable-search-engine-choice-screen')
#   end
# end
# class SmokeTest < SimpleApplicationSystemTestCase

class SmokeTest < ApplicationSystemTestCase
  setup do
    @program = programs(:one)
    @user = users(:one)
    # system_test_login(@user.email, 'geheim12')
  end

  test 'just visit root' do
    visit root_url
    assert_text 'Welcome to the Module Handbook!'
  end
end
