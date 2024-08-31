require 'application_system_test_case'

class SmokeTest < SimpleApplicationSystemTestCase
  setup do
    @program = programs(:one)
    @user = users(:one)
    # system_test_login(@user.email, 'geheim12')
  end

  test 'visiting the index' do
    visit root_url
    #assert false
    #assert_selector 'h1', text: 'Welcome to the Module Handbook!'
  end
end