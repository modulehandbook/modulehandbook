require 'application_system_test_case'

class VersionsTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
    @user = users(:one)
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

  test 'as admin i can create a version on a course' do
    # visit course_path(@course)
    # assert_equal 0, @course.versions.size
    # click_on 'Edit'
    # fill_in 'course_responsible_person', with: 'Not Me'
    # click_on 'Update Course'
    # assert_text 'Course was successfully updated.'
    # assert_equal 1, @course.versions.size
  end

  test 'as admin i can see versions of a comment' do
    visit course_path(@course)
    click_on 'See Course Versions'
    assert_text 'Version History of'
  end

  test 'as admin i can revert to a version of a comment' do

  end
end
