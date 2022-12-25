
module OwnCommentsAssertions
  include CommentsTestsHelper


  # def sees_courses
  #   get "/courses/"
  #   assert_response :success
  #   assert_select 'h3', 'Courses'
  # end

  def comments_course
    assert_text 'Comment saved successfully'
  end

  def read_own_comment
    assert_text @the_comment
  end

  def edit_and_update_own_comment
    the_comment_1 = @the_comment
    the_comment_2 = "This is an edited comment, #{context(__method__)}"

    assert_text the_comment_1
    edit_button(the_comment_1).click

    assert_text 'Edit comment'
    fill_in 'comment_comment', with: the_comment_2
    click_on 'Update Comment'
    click_on 'Go to comments'
    assert_text the_comment_2
    assert_text '(edited)'
  end

  def delete_and_destroy_own_comment
    sleep(1)
    click_on 'Go to comments'
    assert_text @the_comment
    page.accept_confirm do
      delete_button(@the_comment).click
    end
    refute_text @the_comment
  end




  def delete_one_out_of_three_comments
    visit course_path(@course)
    the_comment_1 = "This is the first comment, #{context(__method__)}"
    click_on 'Go to comments'
    fill_in 'comment_comment', with: the_comment_1
    click_on 'Create Comment'
    assert_text the_comment_1
    the_comment_2 = "This is the second comment, #{context(__method__)}"
    click_on 'Go to comments'
    fill_in 'comment_comment', with: the_comment_2
    click_on 'Create Comment'
    assert_text the_comment_2
    the_comment_3 = "This is the third comment, #{context(__method__)}"
    click_on 'Go to comments'
    fill_in 'comment_comment', with: the_comment_3
    click_on 'Create Comment'
    assert_text the_comment_3
    page.accept_confirm do
      delete_button(the_comment_2).click

    end
    assert_text the_comment_1
    refute_text the_comment_2
    assert_text the_comment_3
  end


end
