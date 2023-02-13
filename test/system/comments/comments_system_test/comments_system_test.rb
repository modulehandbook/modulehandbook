require_relative("comments_test_helper.rb")
require_relative("own_comments_assertions.rb")
require_relative("other_comments_assertions.rb")

class CommentsSystemTest < ApplicationSystemTestCase

  include OwnCommentsAssertions
  include OthersCommentsAssertions

  def after_setup
    assert_on_course_page
  end
  def teardown
    # this is not there! click_on 'Go to comments'
    # save_page
    # save_and_open_page
    # take_screenshot
    take_failed_screenshot
    if !failures.empty?
      #puts failures.inspect
      puts "------ output generated on failure in comments_system_test.rb#teardown -------------"

      puts "-----#{name}----role: #{@user ? @user.role : '@user nil'}"
      puts "#{all_comments.size} comments on page (course #{@course.id}): \n #{all_comments.inspect}"
      puts "------ start page -----------------------------------------------------------------"
      puts page.body.inspect
      puts "------ end page -----------------------------------------------------------------"

    end
  end
end
