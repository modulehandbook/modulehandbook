require 'application_system_test_case'

class CommentsTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
    @user = users(:one)
    @user_other = users(:writer)
    sign_in @user
  end

  teardown do
    sign_out @user
    CourseProgram.all.delete_all
    Program.all.delete_all
    Course.all.delete_all
    User.all.delete_all
  end

  test 'as admin i can create a comment on a course' do
    visit course_path(@course)
    fill_in 'comment_comment', with: 'This is a comment'
    click_on 'Create Comment'
    assert_text 'Comment saved successfully'
  end

  test 'as admin i can read own comment' do
    visit course_path(@course)
    fill_in 'comment_comment', with: 'This is a comment'
    click_on 'Create Comment'
    assert_text 'This is a comment'
  end

  test 'as admin i can read others comment' do
    @course.comments.create(author: @user_other, comment: 'The other users comment')
    visit course_path(@course)
    assert_text 'The other users comment'
  end

  test 'as admin i can edit and update own comment' do
    visit course_path(@course)
    fill_in 'comment_comment', with: 'This is a comment'
    click_on 'Create Comment'
    assert_text 'This is a comment'
    within '.table' do
      click_on 'Edit'
    end
    fill_in 'comment_comment', with: 'This is an edited comment'
    click_on 'Update Comment'
    click_on 'Go to comments'
    assert_text 'This is an edited comment'
    assert_text '(edited)'
  end

  test 'as admin i can edit and update others comment' do
    @course.comments.create(author: @user_other, comment: 'The others comment')
    visit course_path(@course)
    assert_text 'The others comment'
    within '.table' do
      assert_text 'Edit'
      click_on 'Edit'
    end
    fill_in 'comment_comment', with: 'This is an edited comment'
    click_on 'Update Comment'
    click_on 'Go to comments'
    assert_text 'This is an edited comment'
    assert_text '(edited)'
  end

  test 'as admin i can delete and destroy own comment' do
    visit course_path(@course)
    fill_in 'comment_comment', with: 'This is a comment'
    click_on 'Create Comment'
    assert_text 'This is a comment'
    accept_alert do
      within '.table' do
        click_on 'Delete'
      end
    end
    refute_text 'This is a comment'
  end

  test 'as admin i can delete and destroy others comment' do
    @course.comments.create(author: @user_other, comment: 'The others comment')
    visit course_path(@course)
    assert_text 'The others comment'
    accept_alert do
      within '.table' do
        assert_text 'Delete'
        click_on 'Delete'
      end
    end
    refute_text 'The others comment'
  end
end
