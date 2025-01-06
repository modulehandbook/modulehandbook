# frozen_string_literal: true

require 'test_helper'

class CourseStatesTest < ActiveSupport::TestCase
  # Course.aasm.events.map { |e| e.name }
  # => [:finish_writing, :no_changes_required, :changes_required, :decisions_complete, :start_update, :finish_updating, :reset_state]

  test 'start with in_progress ' do
    course = Course.new
    assert_equal 'in_progress', course.aasm_state
  end

  test 'finish_writing' do
    course = Course.new
    course.accept_event(:finish_writing)
    assert_equal 'in_review', course.aasm_state
  end

  test 'finish_writing str' do
    course = Course.new
    course.accept_event("finish_writing")
    assert_equal 'in_review', course.aasm_state
  end
end