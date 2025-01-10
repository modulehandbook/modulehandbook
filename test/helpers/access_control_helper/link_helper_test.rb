# frozen_string_literal: true

require 'test_helper'

# The LinkHelper uses cancancan's can? method
# which is not available in ActionView::TestCase
# this MockContext implements the can? method
# and delegates everything else to the current
# test class/object.
# todo: can made more versatile by passing the user object
# as a parameter

class MockContext
  attr_accessor :action_view_test
  def initialize(action_view_test)
    self.action_view_test = action_view_test
  end

 def can?(*args)
    user = users(:one)
    ability = Ability.new(user)
    ability.can?(*args)
 end


  def method_missing(m, *args, &block)
    #puts "Delegating #{m}"
    action_view_test.send(m, *args, &block)
  end

end

include AccessControlHelper::LinkHelper

class LinkHelperTest < ActionView::TestCase

  setup do
    @link_generator = LinkGenerator.new(MockContext.new(self))
  end
  test 'link_to_edit' do
    course = courses(:one)
    link = @link_generator.link_to_edit('Edit Label', course, suffix: ' danach')
    assert_dom_equal %{<a id="edit_course_#{course.id}" href="/courses/#{course.id}/edit">Edit Label</a> danach}, link
  end


end

