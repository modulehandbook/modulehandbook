require 'application_system_test_case'
require_relative 'course_program_versions_test_helper'

class CourseProgramVersionsWriterTest < ApplicationSystemTestCase
  include CourseProgramVersionsTestHelper
  def setup
    @course_program = course_programs(:one)
    @user = users(:writer)
    system_test_login(@user.email, 'geheim12')
  end


  test 'as writer I can create a version on a course program' do
    can_create_version
  end

  test 'as writer I can see versions of a course program' do
    can_see_versions
  end

  test 'as writer I can not revert to a version of a course program' do
    visit course_program_path(@course_program)
    create_version(semester: 1, required: 'mandatory')
    create_version(semester: 2, required: 'elective')
    click_on 'See Course-Program Versions'
    assert_text 'Version History of'
    refute_text 'Revert to this Version'
  end
end
