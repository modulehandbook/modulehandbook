require 'test_helper'

class CourseTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # describe "find_or_create_from_json creates valid course" do
  test 'find_or_create_from_json creates valid course with all details provided' do
    course_json = JSON.parse('{
      "id": 1,
      "name": "Informatik  1",
      "code": "B1",
      "mission": null,
      "ects": 4,
      "examination": null,
      "objectives": null,
      "contents": null,
      "prerequisites": null,
      "literature": null,
      "methods": "P SL/Ü",
      "skills_knowledge_understanding": null,
      "skills_intellectual": null,
      "skills_practical": null,
      "skills_general": null,
      "lectureHrs": null,
      "labHrs": null,
      "tutorialHrs": null,
      "equipment": null,
      "room": null,
      "aasm_state": "in_progress",
      "responsible_person": null,
      "comment": null
    }')
    assert_difference('Course.count', 1) do
      course = Course.find_or_create_from_json(course_json, "2023-02-01", "2023-06-30")
      assert_equal course.code, course_json['code']
    end
  end

  test 'find_or_create_from_json creates valid course with not all details provided' do
    course_json = JSON.parse('{
          "name": "Informatik  1",
          "code": "B3"
          }')
    assert_difference('Course.count', 1) do
      course = Course.find_or_create_from_json(course_json, "2022-02-01", "2022-06-30")
      assert_equal course.code, course_json['code']
    end
  end
    # end
  end
