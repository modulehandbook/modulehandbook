require 'application_system_test_case'

class CommentsEditorAbilitiesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
    @user = users(:editor)
    @user_other = users(:two)
    @ability = Ability.new(@user)
    @comment_own = @course.comments.create(author: @user)
    @comment_other = @course.comments.create(author: @user_other)
    # system_test_login(@user.email, 'geheim12')
  end

  test 'as editor i can create a comment on a course' do
    assert @ability.can?(:create, @comment_own)
    assert @ability.can?(:new, @comment_own)
  end

  test 'as editor i can read own comment' do
    assert @ability.can?(:read, @comment_own)
    assert @ability.can?(:show, @comment_own)
    assert @ability.can?(:index, @comment_own)
  end

  test 'as editor i can read others comment' do
    assert @ability.can?(:read, @comment_other)
    assert @ability.can?(:show, @comment_other)
    assert @ability.can?(:index, @comment_other)
  end

  test 'as editor i can edit and update own comment' do
    assert @ability.can?(:edit, @comment_own)
    assert @ability.can?(:update, @comment_own)
  end

  test 'as editor i cant edit and update others comment' do
    assert @ability.cannot?(:edit, @comment_other)
    assert @ability.cannot?(:update, @comment_other)
  end

  test 'as editor i can delete and destroy own comment' do
    #assert @ability.can?(:delete, @comment_own)
    assert @ability.can?(:destroy, @comment_own)
  end

  test 'as editor i cant delete and destroy others comment' do
    #assert @ability.can?(:delete, @comment_other)
    assert @ability.cannot?(:destroy, @comment_other)
  end

end
