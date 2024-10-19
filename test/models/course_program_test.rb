require 'test_helper'

class CourseProgramTest < ActiveSupport::TestCase
  test 'should be unique to program/course pair' do
    skip
    original = course_programs(:three)
    copy = original.dup
    assert_raises(ActiveRecord::RecordInvalid) do
      copy.save!
    end
  end
end
