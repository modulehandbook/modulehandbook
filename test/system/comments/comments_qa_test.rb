require 'application_system_test_case'
require 'system/comments/comments_dsl'
class CommentsQaTest < CommentsSystemTest

  def setup
    @course = courses(:one)
    @user = users(:qa)
    @user_other = users(:writer)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as qa i can create a comment on a course' do
    comments_course
  end

  test 'as qa i can read own comment' do
    read_own_comment
  end

  test 'as qa i can read others comment' do
    read_others_comment
  end

  test 'as qa i can edit and update own comment' do
    edit_and_update_own_comment
  end

  test 'as qa i cant edit and update others comment' do
    cannot_edit_and_update_others_comment
  end

  test 'as qa i can delete and destroy own comment' do
    delete_and_destroy_own_comment
  end

  test 'as qa i cant delete and destroy others comment' do
    cannot_delete_and_destroy_others_comment
  end
end
