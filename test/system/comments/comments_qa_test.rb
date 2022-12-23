require 'application_system_test_case'
require 'system/comments/comments_system_test/comments_system_test'
class CommentsQaTest < CommentsSystemTest

  def setup
    @course = courses(:one)
    @user = users(:qa)
    own_comments_setup_helper
  end

  test 'as qa i can create a comment on a course' do
    comments_course
  end

  test 'as qa i can read own comment' do
    read_own_comment
  end


  test 'as qa i can edit and update own comment' do
    edit_and_update_own_comment
  end


  test 'as qa i can delete and destroy own comment' do
    delete_and_destroy_own_comment
  end

end
