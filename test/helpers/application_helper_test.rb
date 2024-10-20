# frozen_string_literal: true

require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'test_compare_1' do
    assert_equal(0, compare_course_codes('B1', 'B1'))
  end
  test 'test_compare_2' do
    assert_equal(-1, compare_course_codes('B1', 'B2'))
  end
  test 'test_compare_3' do
    assert_equal(1, compare_course_codes('B2', 'B1'))
  end
  test 'test_compare_4' do
    assert_equal(-1, compare_course_codes('B1', 'B11'))
  end
  test 'test_compare_5' do
    assert_equal(-1, compare_course_codes('B7', 'B11'))
  end
  test 'test_compare_6' do
    assert_equal(1, compare_course_codes('B11', 'B9'))
  end
  test 'test_compare_u' do
    assert_equal(-1, compare_course_codes('B7', 'WT1'))
  end
  test 'test_compare_empty1' do
    assert_equal(-1, compare_course_codes('', 'WT1'))
  end
  test 'test_compare_empty2' do
    assert_equal(1, compare_course_codes('B11', ''))
  end
  test 'test_compare_empty3' do
    assert_equal(-1, compare_course_codes('', ''))
  end
end
