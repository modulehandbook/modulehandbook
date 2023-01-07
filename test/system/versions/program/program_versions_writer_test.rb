require 'application_system_test_case'
require_relative 'program_versions_test_helper'

class ProgramVersionsWriterTest < ApplicationSystemTestCase
  include ProgramVersionsTestHelper

  def setup
    @program = programs(:one)
    @user = users(:writer)
    system_test_login(@user.email, 'geheim12')
  end


  test 'as writer I can create a version on a program' do
    can_create_version
  end

  test 'as writer I can see versions of a program' do
    can_see_versions
  end

  test 'as writer I can not revert to a version of a program' do
    visit program_path(@program)
    create_version(mission: 'OldM', ects: '2')
    create_version(mission: 'NewM', ects: '5')
    click_on 'See Program Versions'
    assert_text 'Version History of'
    refute_text 'Revert to this Version'
  end
end
