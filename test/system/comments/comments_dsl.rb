module CommentsDsl
  def sees_courses
    get "/courses/"
    assert_response :success
    assert_select 'h3', 'Courses'
  end

  def comments_course
    visit course_path(@course)
    the_comment = "This is a comment, #{context(__method__)}"
    fill_in 'comment_comment', with: the_comment
    click_on 'Create Comment'
    assert_text 'Comment saved successfully'
  end

  def read_own_comment
    visit course_path(@course)
    the_comment = "This is a comment, #{context(__method__)}"
    fill_in 'comment_comment', with: the_comment
    click_on 'Create Comment'
    assert_text the_comment
  end

  def read_others_comment
      the_comment = "The others comment #{@user_other.email}, #{context(__method__)}"
    @course.comments.create(author: @user_other, comment: the_comment)
    visit course_path(@course)
    assert_text the_comment
  end

  def edit_and_update_own_comment
    visit course_path(@course)
    the_comment_1 = "This is a comment, #{context(__method__)}"
    the_comment_2 = "This is an edited comment, #{context(__method__)}"
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
    the_comment = "The others comment #{@user_other.email}, #{context(__method__)}"
    the_comment_2 = "Edited comment by #{@user_other.email}, #{context(__method__)}"

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

  def cannot_edit_and_update_others_comment
    the_comment = "The others comment #{@user_other.email}, #{context(__method__)}"

    @course.comments.create(author: @user_other, comment: the_comment)
    visit course_path(@course)
    assert_text the_comment
    refute_edit(the_comment)

  end

  def delete_and_destroy_own_comment
    visit course_path(@course)
    the_comment = "This is a comment, #{context(__method__)}"

    fill_in 'comment_comment', with: the_comment
    click_on 'Create Comment'
    assert_text the_comment
    accept_alert do
      delete_button(the_comment).click
    end
    refute_text the_comment
  end



  def delete_and_destroy_others_comment
    the_comment = "The others comment #{@user_other.email}, #{context(__method__)}"
    @course.comments.create(author: @user_other, comment: the_comment)
    visit course_path(@course)
    assert_text the_comment
    accept_alert do
      delete_button(the_comment).click
    end
    refute_text the_comment
  end

  def cannot_delete_and_destroy_others_comment
    the_comment = "The others comment #{@user_other.email}, #{context(__method__)}"
    @course.comments.create(author: @user_other, comment: the_comment)
    visit course_path(@course)
    assert_text the_comment
    refute_delete(the_comment)

  end

  def delete_one_out_of_three_comments
    visit course_path(@course)
    the_comment_1 = "This is the first comment, #{context(__method__)}"
    fill_in 'comment_comment', with: the_comment_1
    click_on 'Create Comment'
    assert_text the_comment_1
    the_comment_2 = "This is the second comment, #{context(__method__)}"
    fill_in 'comment_comment', with: the_comment_2
    click_on 'Create Comment'
    assert_text the_comment_2
    the_comment_3 = "This is the third comment, #{context(__method__)}"
    fill_in 'comment_comment', with: the_comment_3
    click_on 'Create Comment'
    assert_text the_comment_3
    accept_alert do
      delete_button(the_comment_2).click

    end
    assert_text the_comment_1
    refute_text the_comment_2
  end

  def context(method_name)
    context = "#{@user.role} can #{method_name.to_s.gsub("_"," ")}"
    #puts "---- context: #{context}"
    context
  end
  def comment_id(text)
    element = find(:xpath, "//tr/td[contains(.,'#{text}')]")
    id = element[:id]
  end
  def delete_id(text)
    id = "delete_#{comment_id(text)}"
  end
  def edit_id(text)
    id = "edit_#{comment_id(text)}"
  end
  def delete_button(text)
    find_by_id(delete_id(text))
  end
  def edit_button(text)
    find_by_id(edit_id(text))
  end
  def refute_delete(text)
    assert_no_selector(delete_id(text))
  end
  def refute_edit(text)
    assert_no_selector(edit_id(text))
  end


  def all_comments
    elements = find_all(:xpath, '//table[@id="comments_table"]/tbody/tr/td/p')
    texts = elements.map{|e| e.text(:all)}
    #values = texts = elements.map{|e| e.value}
    #puts elements.inspect
    #puts texts.inspect
    return texts
  end

end

class CommentsSystemTest < ApplicationSystemTestCase
  include CommentsDsl
  def teardown
    click_on 'Go to comments'
    # take_screenshot
    take_failed_screenshot
    if true || ! failures.empty?
      #puts failures.inspect
      puts "-----#{name}----#{@user ? @user.role : '@user nil'}"
      puts "#{all_comments.size} comments on page (course #{@course.id}): \n #{all_comments.inspect}"
    end
  end
end
