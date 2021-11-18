require 'application_system_test_case'

class CommentsTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
    @user = users(:reader)
    @user_other = users(:writer)
    sign_in @user
  end

  teardown do
    sign_out @user
    CourseProgram.all.delete_all
    Program.all.delete_all
    Course.all.delete_all
    User.all.delete_all
  end

  test 'as reader i can not create a version on a course' do
    visit course_path(@course)
    refute_text 'Edit'
  end

  test 'as reader i can not see versions of a comment' do
    visit course_path(@course)
    refute_text 'See Course Versions'
  end

  test 'as reader i can not revert to a version of a comment' do
    visit course_path(@course)
    refute_text 'See Course Versions'
  end
end
