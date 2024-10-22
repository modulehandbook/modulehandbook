# frozen_string_literal: true

require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  setup do
    @course_json = JSON.parse('{
        "id": 1,
        "name": "Informatik  1",
        "code": "B2",
        "mission": "This course\'s mission",
        "ects": 4,
        "examination": "Exam",
        "objectives": "learn programming",
        "contents": "loops and objects",
        "prerequisites": "typing",
        "literature": "a book",
        "methods": "P SL/Ü",
        "skills_knowledge_understanding": "this and that",
        "skills_intellectual": "some intellectual skills",
        "skills_practical": "some practical skills",
        "skills_general": "some general skills",
        "created_at": "2020-08-13T13:27:21.179Z",
        "updated_at": "2020-08-13T13:27:21.179Z",
        "lectureHrs": 4,
        "labHrs": 2,
        "tutorialHrs": 2,
        "equipment": "computer",
        "room": "101"
        }'.gsub('nil', 'null'))
  end

  test 'create from json' do
    assert_equal 'B2', @course_json['code']
    course = Course.new(@course_json)
    assert_equal 'B2', course.code
    course.save!
    assert_equal @course_json['name'], course.name
  end

  # describe "find_or_create_from_json creates valid course" do
  test 'find_or_create_from_json creates valid course with all details provided' do
    assert_difference('Course.count', 1) do
      course = Course.find_or_create_from_json(@course_json)
      keys_to_check = @course_json.keys
      keys_to_check -= %w[id created_at updated_at]
      nil_keys = keys_to_check.select { |key| @course_json[key].nil? }
      keys_to_check -= nil_keys
      nil_keys.each do |key|
        assert_nil course.send(key), "field #{key} is not nil"
      end
      keys_to_check.each do |key|
        value = course.send(key)
        assert_equal @course_json[key], value, "field #{key} does not match"
      end
    end
  end

  test 'find_or_create_from_json creates valid course with not all details provided' do
    course_json = JSON.parse('{
          "name": "Informatik  1",
          "code": "B3"
          }')
    assert_difference('Course.count', 1) do
      course = Course.find_or_create_from_json(course_json)
      assert_equal course.code, course_json['code']
    end
  end
end
