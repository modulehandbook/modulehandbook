require 'application_system_test_case'

class ProgramVersionsReaderTest < ApplicationSystemTestCase
  def setup
    @program = programs(:one)
    @user = users(:reader)
    system_test_login(@user.email, 'geheim12')
  end


  test 'as reader i can not create a version on a program' do
    visit program_path(@program)
    refute_text 'Edit'
  end

  test 'as reader i can not see versions of a program' do
    visit program_path(@program)
    refute_text 'See Program Versions'
  end

  test 'as reader i can not revert to a version of a program' do
    visit program_path(@program)
    refute_text 'See Program Versions'
  end
end
