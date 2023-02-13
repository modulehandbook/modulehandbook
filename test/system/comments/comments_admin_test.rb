require 'application_system_test_case'
require 'system/comments/comments_system_test/comments_system_test'
class CommentsAdminOwnTest < CommentsSystemTest

  def setup
    @user = users(:one)
    @course = courses(:one)
    own_comments_setup_helper
  end

  test 'delete one of three' do
    delete_one_out_of_three_comments
  end
  
end
