require 'application_system_test_case'

class HTWStyleOverviewTest < ApplicationSystemTestCase

  setup do
    @user = users(:one)
    system_test_login(@user.email, 'geheim12')
  end


  test 'bla' do
    assert true
  end
end
