# frozen_string_literal: true

require 'test_helper'

class CourseReaderAbilitiesTest < ActiveSupport::TestCase
  setup do
    @course = courses(:one)
    @user = users(:reader)
    @ability = Ability.new(@user)
    #  system_test_login(@user.email, 'geheim12')
  end

  test 'as reader i cant create a course' do
    assert @ability.cannot?(:create, @course)
    assert @ability.cannot?(:new, @course)
  end

  test 'as reader i can read a course' do
    assert @ability.can?(:read, @course)
    assert @ability.can?(:show, @course)
    assert @ability.can?(:index, @course)
  end

  test 'as reader i cant edit a course' do
    assert @ability.cannot?(:edit, @course)
    assert @ability.cannot?(:update, @course)
  end

  test 'as reader i cant see or revert to course versions' do
    assert @ability.cannot?(:versions, @course)
    assert @ability.cannot?(:revert_to, @course)
  end

  test 'as reader i cant change the state' do
    assert @ability.cannot?(:change_state, @course)
  end

  test 'as reader i cant delete a course' do
    assert @ability.cannot?(:delete, @course)
    assert @ability.cannot?(:destroy, @course)
  end

  test 'as reader i can use a courses export actions' do
    assert @ability.can?(:export_course_json, @course)
    assert @ability.can?(:export_courses_json, @course)
    assert @ability.can?(:export_course_docx, @course)
  end

  test 'as reader i cant use a courses import action' do
    assert @ability.cannot?(:import_course_json, @course)
  end
end
