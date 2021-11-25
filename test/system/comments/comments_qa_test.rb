require 'application_system_test_case'

class CommentsQATest < ApplicationSystemTestCase
  def setup
    @course = courses(:one)
    @user = users(:qa)
    @user_other = users(:writer)
    sign_in @user
  end

  def teardown
    sign_out @user
    CourseProgram.all.delete_all
    Program.all.delete_all
    Course.all.delete_all
    User.all.delete_all
  end

  test 'as qa i can create a comment on a course' do
    visit course_path(@course)
    fill_in 'comment_comment', with: 'This is a comment'
    click_on 'Create Comment'
    assert_text 'Comment saved successfully'
  end

  test 'as qa i can read own comment' do
    visit course_path(@course)
    fill_in 'comment_comment', with: 'This is a comment'
    click_on 'Create Comment'
    assert_text 'This is a comment'
  end

  test 'as qa i can read others comment' do
    @course.comments.create(author: @user_other, comment: 'The other users comment')
    visit course_path(@course)
    assert_text 'The other users comment'
  end

  test 'as qa i can edit and update own comment' do
    visit course_path(@course)
    fill_in 'comment_comment', with: 'This is a comment'
    click_on 'Create Comment'
    assert_text 'This is a comment'
    within '.table' do
      click_on 'Edit'
    end
    assert_text 'Edit comment:'
    fill_in 'comment_comment', with: 'This is an edited comment'
    click_on 'Update Comment'
    click_on 'Go to comments'
    assert_text 'This is an edited comment'
    assert_text '(edited)'
  end

  test 'as qa i cant edit and update others comment' do
    @course.comments.create(author: @user_other, comment: 'The other users comment')
    visit course_path(@course)
    assert_text 'The other users comment'
    within '.table' do
      refute_text 'Edit'
    end
  end

  test 'as qa i can delete and destroy own comment' do
    visit course_path(@course)
    fill_in 'comment_comment', with: 'This is a comment'
    click_on 'Create Comment'
    assert_text 'This is a comment'
    accept_alert do
      click_on 'Delete'
    end
    refute_text 'This is a comment'
  end

  test 'as qa i cant delete and destroy others comment' do
    @course.comments.create(author: @user_other, comment: 'The other users comment')
    visit course_path(@course)
    assert_text 'The other users comment'
    refute_text 'Delete'
  end
end
