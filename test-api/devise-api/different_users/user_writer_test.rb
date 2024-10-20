# frozen_string_literal: true

require 'application_system_test_case'

class UserWriterTest < ApplicationSystemTestCase
  def setup
    @user_writer = users(:writer)
    @user = @user_writer
    system_test_login(@user.email, 'geheim12')
  end

  def teardown
    system_test_logout
  end

  test 'writer is logged in' do
    # Logged in as admin@mail.de
    visit root_path
    assert_text "Logged in as #{@user.email}"
  end
end
