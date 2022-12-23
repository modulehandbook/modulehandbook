require 'application_system_test_case'
require 'system/comments/comments_system_test/comments_system_test'

class CommentsAdminOthersCommentsTest < CommentsSystemTest

  def setup
    @user = users(:one)
    @course = courses(:one)
    other_comments_setup_helper
  end

  test 'as admin i can read others comment' do
    read_others_comment
  end

  test 'as admin i can edit and update others comment' do
    edit_and_update_others_comment
  end


  test 'as admin i can delete and destroy others comment' do
    delete_and_destroy_others_comment
  end
end
