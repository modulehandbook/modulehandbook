# frozen_string_literal: true

require 'application_system_test_case'

class CourseProgramReaderAbilitiesTest < ApplicationSystemTestCase
  setup do
    @course_program = course_programs(:one)
    @user = users(:reader)
    @ability = Ability.new(@user)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as reader i cant create a course_program' do
    assert @ability.cannot?(:create, @course_program)
    assert @ability.cannot?(:new, @course_program)
  end

  test 'as reader i can read a course_program' do
    assert @ability.can?(:read, @course_program)
    assert @ability.can?(:show, @course_program)
    assert @ability.can?(:index, @course_program)
  end

  test 'as reader i cant edit and update a course_program' do
    assert @ability.cannot?(:edit, @course_program)
    assert @ability.cannot?(:update, @course_program)
  end

  test 'as reader i cant delete and destroy a course_program' do
    assert @ability.cannot?(:delete, @course_program)
    assert @ability.cannot?(:destroy, @course_program)
  end
end
