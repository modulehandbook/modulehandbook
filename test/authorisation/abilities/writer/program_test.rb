# frozen_string_literal: true

require 'test_helper'

class ProgramWriterAbilitiesTest <  ActiveSupport::TestCase
  setup do
    @program = programs(:one)
    @user = users(:writer)
    @ability = Ability.new(@user)
    # system_test_login(@user.email, 'geheim12')
  end

  test 'as writer i can create a program' do
    assert @ability.can?(:create, @program)
    assert @ability.can?(:new, @program)
  end

  test 'as writer i can read a program' do
    assert @ability.can?(:read, @program)
    assert @ability.can?(:show, @program)
    assert @ability.can?(:index, @program)
  end

  test 'as writer i can edit and update a program' do
    assert @ability.can?(:edit, @program)
    assert @ability.can?(:update, @program)
  end

  test 'as writer i can delete and destroy a program' do
    assert @ability.can?(:delete, @program)
    assert @ability.can?(:destroy, @program)
  end

  test 'as writer i can use a programs export actions' do
    assert @ability.can?(:export_program_json, @program)
    assert @ability.can?(:export_programs_json, @program)
    assert @ability.can?(:export_program_docx, @program)
  end

  test 'as writer i can use a programs import action' do
    assert @ability.can?(:import_program_json, @program)
  end
end
