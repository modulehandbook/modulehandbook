require 'application_system_test_case'

class DeviseApiTest < ApplicationSystemTestCase
  def setup
    @user_editor = users(:editor)
    @user = @user_editor
    sign_in @user
  end

  def teardown
    sign_out @user
  end

  test 'editor is logged in' do
    # Logged in as admin@mail.de
    visit root_path
    assert_text 'Logged in as '+@user.email
  end

end
