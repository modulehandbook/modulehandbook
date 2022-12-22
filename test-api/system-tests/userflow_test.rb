require "test_helper"


## adapted from https://api.rubyonrails.org/v7.0.4/classes/ActionDispatch/IntegrationTest.html
class UserFlowsIntegrationTest < ActionDispatch::IntegrationTest
  test "login and browse site" do
    # User david logs in
    @admin = users(:one)
    david = login(:one)
    # User guest logs in
    guest = login(:writer)

    # Both are now available in different sessions
    flash_message = I18n.t('devise.sessions.signed_in')
    assert_equal flash_message, david.flash[:notice]
    assert_equal flash_message, guest.flash[:notice]

    # User david can browse site
    david.sees_courses
    # User guest can browse site as well
    guest.sees_courses

    # Continue with other assertions
  end

  private

    module CustomDsl
      def sees_courses
        get "/courses/"
        assert_response :success
        assert_select 'h3', 'Courses'
      end
    end

    def login(user)
      open_session do |sess|
        sess.extend(CustomDsl)
        u = users(user)
        # sess.https!
        # user_session POST   /users/sign_in(.:format)
        sess.post("/users/sign_in", params: { "user[email]" => u.email, "user[password]" =>  'geheim12',
          "user_email" => u.email, "user_password" =>  'geheim12'  })
          
        sess.follow_redirect!
        assert_equal '/', sess.path
        assert_equal UserFlowsIntegrationTest, sess.class

        assert_equal ActionDispatch::TestResponse, sess.response.class
        assert_equal WelcomeController, sess.controller.class
        assert_equal u, sess.controller.current_user

        # sess.https!(false)
        sess
      end
    end
end
