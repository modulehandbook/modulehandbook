# frozen_string_literal: true

module CommentsTestsHelper
  def base_setup_helper
    system_test_login(@user.email, 'geheim12')
  end

  def own_comments_setup_helper
    base_setup_helper
    @the_comment = "This is a comment, #{context(__method__)}"
    visit course_path(@course)
    fill_in 'comment_comment', with: @the_comment
    click_on 'Create Comment'
  end

  def other_comments_setup_helper
    base_setup_helper
    @user_other = users(:author_of_other_comment)
    @the_comment = "The others comment #{@user_other.email}, #{context(__method__)}"
    @course.comments.create(author: @user_other, comment: @the_comment)
    visit course_path(@course)
  end

  def context(_method_name)
    "ROLE: #{@user.role} in TEST: #{name.to_s.gsub('_', ' ')}"
    # puts "---- context: #{context}"
  end

  def comment_id(text)
    element = find(:xpath, "//tr/td[contains(.,'#{text}')]")
    element[:id]
  end

  def delete_id(text)
    "delete_#{comment_id(text)}"
  end

  def edit_id(text)
    "edit_#{comment_id(text)}"
  end

  def delete_button(text)
    can_delete = find_by_id(delete_id(text))
    assert_not_nil can_delete
    can_delete
  end

  def edit_button(text)
    can_edit = find_by_id(edit_id(text))
    assert_not_nil can_edit
    can_edit
  end

  def refute_delete(text)
    assert_no_selector(delete_id(text))
  end

  def refute_edit(text)
    assert_no_selector(edit_id(text))
  end

  def assert_on_course_page
    nil if page.has_content?(@course.name)
    # puts "Not on course page!"
    # puts page.body.inspect
    # save_and_open_page
  end

  def all_comments
    elements = find_all(:xpath, '//table[@id="comments_table"]/tbody/tr/td/p')
    elements.map { |e| e.text(:all) }
    # values = texts = elements.map{|e| e.value}
    # puts elements.inspect
    # puts texts.inspect
  end
end
