require 'application_system_test_case'

class CourseVersionsReaderTest < ApplicationSystemTestCase
  def setup
    @course = courses(:one)
    @user = users(:reader)
    @user_other = users(:writer)
    system_test_login(@user.email, 'geheim12')
  end

  test 'logged in as reader' do
    visit root_path
    assert_text 'Logged in as ' + @user.email
  end

  test 'as reader i can not create a version on a course' do
    visit course_path(@course)
    refute_text 'Edit'
  end

  test 'as reader i can not see versions of a course' do
    visit course_path(@course)
    refute_text 'See Course Versions'
  end

  test 'as reader i can not revert to a version of a course' do
    visit course_path(@course)
    refute_text 'See Course Versions'
  end
end
