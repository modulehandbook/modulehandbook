require 'application_system_test_case'
require_relative 'semester_test_helper'

class SemestersEditorTest < ApplicationSystemTestCase
  include SemesterTestHelper
  def setup
    @user = users(:editor)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as editor I can see semesters' do
    visit semesters_path
    assert_text 'Semesters'
  end

  test 'as editor I can create semester' do
    create_semester
    assert_text 'Semester created successfully'
  end


end
