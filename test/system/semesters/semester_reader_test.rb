require 'application_system_test_case'
require_relative 'semester_test_helper'

class SemestersReaderTest < ApplicationSystemTestCase
  include SemesterTestHelper
  def setup
    @user = users(:reader)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as reader I can see semesters' do
    visit semesters_path
    assert_text 'Semesters'
  end

  test 'as reader I can not create semester' do
    visit semesters_path
    refute_text 'New Semester'
  end


end
