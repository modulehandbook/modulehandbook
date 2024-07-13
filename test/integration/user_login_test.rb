require "test_helper"

class UserLoginTest < ActionDispatch::IntegrationTest
  test "can see the welcome page" do
    get "/"
    assert_select "h1", "Welcome to the Module Handbook"
  end
  test "login" do
    post "/users/sign_in",
      params: { user: { email: "admin@mail.de", password: "geheim12" } }
    assert_response :success
    #follow_redirect!
  end
end
