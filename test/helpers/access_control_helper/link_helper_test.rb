# frozen_string_literal: true

require 'test_helper'

module AccessControlHelper
  module LinkHelper
    def my_can?(*args)
      user = users(:one)
      ability = Ability.new(user)
      ability.can?(*args)
    end
  end
end

include AccessControlHelper::LinkHelper

class LinkHelperTest < ActionView::TestCase
  test 'link_to_edit' do
    course = courses(:one)
    link = link_to_edit('Edit Label', course, suffix: ' danach')
    assert_dom_equal %{<a id="edit_course_#{course.id}" href="/courses/#{course.id}/edit">Edit Label</a> danach}, link
  end


end

