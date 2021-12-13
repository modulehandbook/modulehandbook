# frozen_string_literal: true

require 'application_system_test_case'

class CourseWriterAbilitiesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
    @user = users(:writer)
    @ability = Ability.new(@user)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as writer i can create a course' do
    assert @ability.can?(:create, @course)
    assert @ability.can?(:new, @course)
  end

  test 'as writer i can read a course' do
    assert @ability.can?(:read, @course)
    assert @ability.can?(:show, @course)
    assert @ability.can?(:index, @course)
  end

  test 'as writer i can edit a course' do
    assert @ability.can?(:edit, @course)
    assert @ability.can?(:update, @course)
  end

  test 'as writer i can see but not revert to course versions' do
    assert @ability.can?(:versions, @course)
    assert @ability.cannot?(:revert_to, @course)
  end

  test 'as writer i cant change the state' do
    assert @ability.cannot?(:change_state, @course)
  end

  test 'as writer i can delete a course' do
    assert @ability.can?(:delete, @course)
    assert @ability.can?(:destroy, @course)
  end

  test 'as writer i can use a courses export actions' do
    assert @ability.can?(:export_course_json, @course)
    assert @ability.can?(:export_courses_json, @course)
  end

  test 'as writer i can use a courses import action' do
    assert @ability.can?(:import_course_json, @course)
  end
end
