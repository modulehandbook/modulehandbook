require "test_helper"

class AbilitiesControllerTest < ActionDispatch::IntegrationTest

  setup do
    @admin = users(:one)
    @qa = users(:qa)
    sign_in @admin
    @controller = AbilitiesController.new
  end

  test 'show index / abilities overview' do
    sign_in @admin
    get abilities_path
    # headers: {
    #  Authorization: ActionController::HttpAuthentication::Basic.encode_credentials(
    #    "one@host.org", "geheim12") }

    assert_response :success
  end

  test 'actions_by_controller'do
    skip
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

  test 'actions_by_model' do
    actions = @controller.actions_by_model
    assert actions.size > 0
  end


end
