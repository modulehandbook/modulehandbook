# frozen_string_literal: true

require 'test_helper'

class ProgramQAAbilitiesTest <  ActiveSupport::TestCase
  setup do
    @program = programs(:one)
    @user = users(:qa)
    @ability = Ability.new(@user)
    # system_test_login(@user.email, 'geheim12')
  end

  test 'as qa i can create a program' do
    assert @ability.can?(:create, @program)
    assert @ability.can?(:new, @program)
  end

  test 'as qa i can read a program' do
    assert @ability.can?(:read, @program)
    assert @ability.can?(:show, @program)
    assert @ability.can?(:index, @program)
  end

  test 'as qa i can edit and update a program' do
    assert @ability.can?(:edit, @program)
    assert @ability.can?(:update, @program)
  end

  test 'as qa i can delete and destroy a program' do
    assert @ability.can?(:delete, @program)
    assert @ability.can?(:destroy, @program)
  end

  test 'as qa i can use a programs export actions' do
    assert @ability.can?(:export_program_json, @program)
    assert @ability.can?(:export_programs_json, @program)
    assert @ability.can?(:export_program_docx, @program)
  end

  test 'as qa i can use a programs import action' do
    assert @ability.can?(:import_program_json, @program)
  end
end
