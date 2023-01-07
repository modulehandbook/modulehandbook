require 'application_system_test_case'
require_relative 'course_versions_test_helper'


class CourseVersionsEditorTest < ApplicationSystemTestCase
  include CourseVersionsTestHelper

  def setup
    @course = courses(:one)
    @user = @user_editor = users(:editor)
    @user_other = users(:writer)
    system_test_login(@user.email, 'geheim12')
  end


  test 'as editor i can create a version on a course' do
    can_create_version
  end

  test 'as editor i can see versions of a course' do
    can_see_versions
  end

  test 'as editor i can revert to a version of a course' do
    can_revert_version
  end
end
