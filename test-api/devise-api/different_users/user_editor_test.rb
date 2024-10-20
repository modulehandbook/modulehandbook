# frozen_string_literal: true

require 'application_system_test_case'

class UserEditorTest < ApplicationSystemTestCase
  def setup
    @user_editor = users(:editor)
    @user = @user_editor
    system_test_login(@user.email, 'geheim12')
  end

  def teardown
    system_test_logout
  end

  test 'editor is logged in' do
    # Logged in as admin@mail.de
    visit root_path
    assert_text "Logged in as #{@user.email}"
  end
end
