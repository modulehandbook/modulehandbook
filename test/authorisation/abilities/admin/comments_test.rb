require 'application_system_test_case'

class CommentsAdminAbilitiesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
    @user = users(:one)
    @ability = Ability.new(@user)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as admin i can create a comment on a course' do
    assert @ability.can?(:create, @course)
    assert @ability.can?(:new, @course)
  end

  test 'as admin i can read own comment' do
    # assert @ability.can?(:read, @course_program)
    # assert @ability.can?(:show, @course_program)
    # assert @ability.can?(:index, @course_program)
  end

  test 'as admin i can read others comment' do
    # assert @ability.can?(:read, @course_program)
    # assert @ability.can?(:show, @course_program)
    # assert @ability.can?(:index, @course_program)
  end

  test 'as admin i can edit and update own comment' do
    # assert @ability.can?(:edit, @course_program)
    # assert @ability.can?(:update, @course_program)
  end

  test 'as admin i can edit and update others comment' do
    # assert @ability.can?(:edit, @course_program)
    # assert @ability.can?(:update, @course_program)
  end

  test 'as admin i can delete and destroy own comment' do
    # assert @ability.can?(:delete, @course_program)
    # assert @ability.can?(:destroy, @course_program)
  end

  test 'as admin i can delete and destroy others comment' do
    # assert @ability.can?(:delete, @course_program)
    # assert @ability.can?(:destroy, @course_program)
  end

end

# dann noch system test schrieben


# can %i[create], Comment
# can %i[destroy], Comment, author_id: _user.id
# can %i[edit update], Comment, Comment.where(author_id: _user.id) do |comment|
#   comment.created_at >= 30.minutes.ago
# end
