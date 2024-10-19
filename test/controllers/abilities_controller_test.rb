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

  test 'collect controller' do

    all_controller = controller.all_app_controllers
    assert_includes all_controller, UsersController
  end

  test 'all_actions' do
      all_actions = @controller.all_controller_actions
      assert_includes all_actions, {:controller=>"faculties", :action=>"show"}
  end
end
