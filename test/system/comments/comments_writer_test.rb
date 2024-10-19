require 'application_system_test_case'
require 'system/comments/comments_system_test/comments_system_test'
class CommentsWriterTest < CommentsSystemTest
  def setup
    @course = courses(:one)
    @user = users(:writer)
    own_comments_setup_helper
  end

  test 'as writer i can create a comment on a course' do
    comments_course
  end

  test 'as writer i can read own comment' do
    read_own_comment
  end

  test 'as writer i can edit and update own comment' do
    edit_and_update_own_comment
  end

  test 'as writer i can delete and destroy own comment' do
    delete_and_destroy_own_comment
  end
end
