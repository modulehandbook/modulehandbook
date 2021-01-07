# frozen_string_literal: true

require 'application_system_test_case'

class CourseProgramAdminAbilitiesTest < ApplicationSystemTestCase
  setup do
    @course_program = course_programs(:one)
    @user = users(:one)
    @ability = Ability.new(@user)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as admin i can create a course_program' do
    assert @ability.can?(:create, @course_program)
    assert @ability.can?(:new, @course_program)
  end

  test 'as admin i can read a course_program' do
    assert @ability.can?(:read, @course_program)
    assert @ability.can?(:show, @course_program)
    assert @ability.can?(:index, @course_program)
  end

  test 'as admin i can edit and update a course_program' do
    assert @ability.can?(:edit, @course_program)
    assert @ability.can?(:update, @course_program)
  end

  test 'as admin i can delete and destroy a course_program' do
    assert @ability.can?(:delete, @course_program)
    assert @ability.can?(:destroy, @course_program)
  end

end
