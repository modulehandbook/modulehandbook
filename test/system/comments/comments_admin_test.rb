require 'application_system_test_case'
require 'system/comments/comments_dsl'
class CommentsAdminTest < CommentsSystemTest

  def setup
    @course = courses(:one)
    @user = users(:one)
     system_test_login(@user.email, 'geheim12')
    @user_other = users(:writer)

  end

  test 'one of two' do
    delete_one_out_of_two_comments
  end
  test ('as admin i can create a comment on a course') do
     comments_course
   end

  test 'as admin i can read own comment' do
    read_own_comment
  end

  test 'as admin i can read others comment' do
    read_others_comment
  end

  test 'as admin i can edit and update own comment' do
    edit_and_update_own_comment
  end

  test 'as admin i can edit and update others comment' do
    edit_and_update_others_comment
  end

  test 'as admin i can delete and destroy own comment' do
    delete_and_destroy_own_comment
  end

  test 'as admin i can delete and destroy others comment' do
    delete_and_destroy_others_comment
  end
end
