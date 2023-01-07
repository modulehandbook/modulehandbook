require 'application_system_test_case'
require_relative 'course_versions_test_helper'

class CourseVersionsWriterTest < ApplicationSystemTestCase
  include CourseVersionsTestHelper
  def setup
    @course = courses(:one)
    @user = users(:writer)
    @user_other = users(:reader)
    system_test_login(@user.email, 'geheim12')
  end


  test 'as writer i can create a version on a course' do
    can_create_version
  end

  test 'as writer i can see versions of a course' do
    can_see_versions
  end

  test 'as writer i can not revert to a version of a course' do
    visit course_path(@course)
    create_version(responsible_person: 'Me', ects: '2')
    create_version(responsible_person: 'Not Me', ects: '5')
    click_on 'See Course Versions'
    assert_text 'Version History of'
    refute_text 'Revert to this Version'
  end
end
