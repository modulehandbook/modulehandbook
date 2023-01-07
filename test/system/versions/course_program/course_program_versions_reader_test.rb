require 'application_system_test_case'

class CourseProgramVersionsReaderTest < ApplicationSystemTestCase
  def setup
    @course_program = course_programs(:one)
    @user = users(:reader)
    system_test_login(@user.email, 'geheim12')
  end


  test 'as reader i can not create a version on a course program' do
    visit course_program_path(@course_program)
    refute_text 'Edit'
  end

  test 'as reader i can not see versions of a course program' do
    visit course_program_path(@course_program)
    refute_text 'See Course-Program Versions'
  end

  test 'as reader i can not revert to a version of a course program' do
    visit course_program_path(@course_program)
    refute_text 'See Course-Program Versions'
  end
end
