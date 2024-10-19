# frozen_string_literal: true

require 'test_helper'
class ProgramActionCopyTest < ActiveSupport::TestCase
  setup do
    @program = programs(:copy_test)
  end
  test 'make sure fixture associations work as expected' do
    assert_equal 3, @program.courses.size
    codes = @program.courses.map { |course| course.code }
    assert_includes codes, 'CC01'
    assert_includes codes, 'CC02'
    assert_includes codes, 'CC03'
  end
  test 'program shallow copy' do
    skip
    program_copy = @program.shallow_copy
    assert_equal 3, program_copy.courses.size
    program_copy.courses.map { |course| course.code }
    # assert_includes codes, 'CC01'
    # assert_includes codes, 'CC02'
    # assert_includes codes, 'CC03'
    # assert_not_equal program.id, @program.id
  end
end
