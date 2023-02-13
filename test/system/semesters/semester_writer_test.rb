require 'application_system_test_case'
require_relative 'semester_test_helper'

class SemestersWriterTest < ApplicationSystemTestCase
  include SemesterTestHelper
  def setup
    @user = users(:writer)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as writer I can see semesters' do
    visit semesters_path
    assert_text 'Semesters'
  end

  test 'as writer I can create semester' do
    create_semester
    assert_text 'Semester created successfully'
  end


end
