require 'application_system_test_case'
require_relative 'program_versions_test_helper'


class ProgramVersionsEditorTest < ApplicationSystemTestCase
  include ProgramVersionsTestHelper
  def setup
    @program = programs(:one)
    @user = users(:editor)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as editor I can create a version on a program' do
    can_create_version
  end

  test 'as editor I can see versions of a program' do
    can_see_versions
  end

  test 'as editor I can revert to a version of a program' do
    can_revert_version
  end
end
