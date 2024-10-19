# frozen_string_literal: true

module OthersCommentsAssertions
  include CommentsTestsHelper

  def read_others_comment
    assert_text @the_comment
  end

  def edit_and_update_others_comment
    the_comment_2 = "Edited comment by #{@user_other.email}, #{context(__method__)}"
    assert_text @the_comment
    edit_button(@the_comment).click
    fill_in 'comment_comment', with: the_comment_2
    click_on 'Update Comment'
    click_on 'Go to comments'
    assert_text the_comment_2
    assert_text '(edited)'
  end

  def cannot_edit_and_update_others_comment
    assert_text @the_comment
    refute_edit(@the_comment)
  end

  def delete_and_destroy_others_comment
    skip
    assert_text @the_comment
    accept_alert do
      delete_button(@the_comment).click
    end
    refute_text @the_comment
  end

  def cannot_delete_and_destroy_others_comment
    assert_text @the_comment
    refute_delete(@the_comment)
  end
end
