# frozen_string_literal: true

require 'application_system_test_case'

class ProgramAdminAbilitiesTest < ApplicationSystemTestCase
  setup do
    @program = programs(:one)
    @user = users(:one)
    @ability = Ability.new(@user)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as admin i can create a program' do
    assert @ability.can?(:create, @program)
    assert @ability.can?(:new, @program)
  end

  test 'as admin i can read a program' do
    assert @ability.can?(:read, @program)
    assert @ability.can?(:show, @program)
    assert @ability.can?(:index, @program)
  end

  test 'as admin i can edit and update a program' do
    assert @ability.can?(:edit, @program)
    assert @ability.can?(:update, @program)
  end

  test 'as admin i can delete and destroy a program' do
    assert @ability.can?(:delete, @program)
    assert @ability.can?(:destroy, @program)
  end

  test 'as admin i can use a programs export actions' do
    assert @ability.can?(:export_program_json, @program)
    assert @ability.can?(:export_programs_json, @program)
    assert @ability.can?(:export_program_docx, @program)
  end

  test 'as admin i can use a programs import action' do
    assert @ability.can?(:import_program_json, @program)
  end
end
