require "test_helper"

class AbilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @qa = users(:qa)
    sign_in @admin

  end
  test 'show index / abilities overview' do
    get abilities_path
    assert_response :success
  end
end
