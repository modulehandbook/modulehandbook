# frozen_string_literal: true

require 'application_system_test_case'

class ProgramReaderAbilitiesTest < ApplicationSystemTestCase
  setup do
    @program = programs(:one)
    @user = users(:reader)
    @ability = Ability.new(@user)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as reader i cant create a program' do
    assert @ability.cannot?(:create, @program)
    assert @ability.cannot?(:new, @program)
  end

  test 'as reader i can read a program' do
    assert @ability.can?(:read, @program)
    assert @ability.can?(:show, @program)
    assert @ability.can?(:index, @program)
  end

  test 'as reader i cant edit and update a program' do
    assert @ability.cannot?(:edit, @program)
    assert @ability.cannot?(:update, @program)
  end

  test 'as reader i cant delete and destroy a program' do
    assert @ability.cannot?(:delete, @program)
    assert @ability.cannot?(:destroy, @program)
  end

  test 'as reader i can use a programs export actions' do
    assert @ability.can?(:export_program_json, @program)
    assert @ability.can?(:export_programs_json, @program)
    assert @ability.can?(:export_program_docx, @program)
  end

  test 'as reader i cant use a programs import action' do
    assert @ability.cannot?(:import_program_json, @program)
  end

end
