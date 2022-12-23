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
  test ('as admin i can create a comment on a course') do
     comments_course
   end

  test 'as admin i can read own comment' do
    read_own_comment
  end

  test 'as admin i can edit and update own comment' do
    edit_and_update_own_comment
  end

  test 'as admin i can delete and destroy own comment' do
    delete_and_destroy_own_comment
  end

end
