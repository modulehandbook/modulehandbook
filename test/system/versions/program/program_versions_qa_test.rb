require 'application_system_test_case'
require_relative 'program_versions_test_helper'

class ProgramVersionsQATest < ApplicationSystemTestCase
  include ProgramVersionsTestHelper

  def setup
    @program = programs(:one)
    @user = users(:qa)
    system_test_login(@user.email, 'geheim12')
  end


  test 'as qa I can create a version on a program' do
    can_create_version
  end

  test 'as qa I can see versions of a program' do
    can_see_versions
  end

  test 'as qa I can revert to a version of a program' do
    can_revert_version
  end
end
