require 'application_system_test_case'

class UserWriterTest < ApplicationSystemTestCase
  def setup
    @user_writer = users(:writer)
    @user = @user_writer
    sign_in @user
  end

  def teardown
    sign_out @user
  end

  test 'writer is logged in' do
    # Logged in as admin@mail.de
    visit root_path
    assert_text 'Logged in as '+@user.email
  end

end
