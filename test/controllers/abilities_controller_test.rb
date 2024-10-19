require "test_helper"

class AbilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = users(:one)
    @qa = users(:qa)
    sign_in @admin
    @controller = AbilitiesController.new

  end
  test 'show index / abilities overview' do
    get abilities_path
    assert_response :success
  end

  test 'actions_by_controller'do
    actions_by_controller = @controller.actions_by_controller
    assert_equal actions_by_controller['abilities'], ['index']
  end
  test 'all_routes' do
    all_routes  = @controller.all_routes
    assert_includes all_routes, {:controller=>"faculties", :action=>"show"}
  end

  test 'all_controllers' do
    all_controllers  = @controller.all_controllers
    assert_includes all_controllers, 'faculties'
  end
end
