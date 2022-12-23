module CommentsDsl
  def sees_courses
    get "/courses/"
    assert_response :success
    assert_select 'h3', 'Courses'
  end

  def comments_course
    visit course_path(@course)
    the_comment = "This is a comment, #{context}"
    fill_in 'comment_comment', with: the_comment
    click_on 'Create Comment'
    assert_text 'Comment saved successfully'
  end

  def read_own_comment
    visit course_path(@course)
    the_comment = "This is a comment, #{context}"
    fill_in 'comment_comment', with: the_comment
    click_on 'Create Comment'
    assert_text the_comment
  end

  def read_others_comment
      the_comment = "The others comment #{@user_other.email}, #{context}"
    @course.comments.create(author: @user_other, comment: the_comment)
    visit course_path(@course)
    assert_text the_comment
  end

  def edit_and_update_own_comment
    visit course_path(@course)
    the_comment_1 = "This is a comment, #{context}"
    the_comment_2 = "This is an edited comment, #{context}"
    fill_in 'comment_comment', with: the_comment_1
    click_on 'Create Comment'
    assert_text the_comment_1
    edit_button(the_comment_1).click
    # within '.table' do
    #   click_on 'Edit'
    # end
    fill_in 'comment_comment', with: the_comment_2
    click_on 'Update Comment'
    click_on 'Go to comments'
    assert_text the_comment_2
    assert_text '(edited)'
  end

  def edit_and_update_others_comment
    the_comment = "The others comment #{@user_other.email}, #{context}"
    the_comment_2 = "Edited comment by #{@user_other.email}, #{context}"

    @course.comments.create(author: @user_other, comment: the_comment)
    visit course_path(@course)
    assert_text the_comment
    edit_button(the_comment).click
    fill_in 'comment_comment', with: the_comment_2
    click_on 'Update Comment'
    click_on 'Go to comments'
    assert_text the_comment_2
    assert_text '(edited)'
  end

  def delete_and_destroy_own_comment
    visit course_path(@course)
    the_comment = "This is a comment, #{context}"

    fill_in 'comment_comment', with: the_comment
    click_on 'Create Comment'
    assert_text the_comment
    accept_alert do
      delete_button(the_comment).click
    end
    refute_text the_comment
  end

  def delete_one_out_of_two_comments
    visit course_path(@course)
    the_comment_1 = "This is the first comment, #{context}"
    fill_in 'comment_comment', with: the_comment_1
    click_on 'Create Comment'
    assert_text the_comment_1
    the_comment_2 = "This is the second comment, #{context}"
    fill_in 'comment_comment', with: the_comment_2
    click_on 'Create Comment'
    assert_text the_comment_2
    accept_alert do
      delete_button(the_comment_2).click

    end
    assert_text the_comment_1
    refute_text the_comment_2
  end

  def delete_and_destroy_others_comment
    the_comment = "The others comment #{@user_other.email}, #{context}"
    @course.comments.create(author: @user_other, comment: the_comment)
    visit course_path(@course)
    assert_text the_comment
    accept_alert do
      delete_button(the_comment).click
    end
    refute_text the_comment
  end


  def context
    "#{@user.role} can #{__method__.to_s.gsub("_"," ")}"
  end
  def comment_id(text)
    element = find(:xpath, "//tr/td[contains(.,'#{text}')]")
    id = element[:id]
  end
  def delete_button(text)
    id = "delete_#{comment_id(text)}"
    find_by_id(id)
  end
  def edit_button(text)
    id = "edit_#{comment_id(text)}"
    find_by_id(id)
  end


end

class CommentsSystemTest < ApplicationSystemTestCase
  include CommentsDsl
end
