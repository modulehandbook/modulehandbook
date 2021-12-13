require 'application_system_test_case'

class DeviseApiTest < ApplicationSystemTestCase
  setup do
    @user_editor = users(:editor)
    @user_writer = users(:writer)
    @user = @user_writer
    sign_in @user
  end

  teardown do
    sign_out @user
    CourseProgram.all.delete_all
    Program.all.delete_all
    Course.all.delete_all
    User.all.delete_all
  end

  test 'is logged in' do
    # Logged in as admin@mail.de
    visit root_path
    assert_text 'Logged in as '+@user_writer.email
  end

  test 'switch user' do
    # Logged in as admin@mail.de
    sign_out @user
    sign_in @user_editor
    visit root_path

    assert_text 'Logged in as '+@user_editor.email
  end


end
