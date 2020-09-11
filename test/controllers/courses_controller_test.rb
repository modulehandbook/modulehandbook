require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  setup do
    @course = courses(:one)
    sign_in users(:one)
  end

  test "should get index" do
    get courses_url
    assert_response :success
  end

  test "should get new" do
    get new_course_url
    assert_response :success
  end

  test "should create course" do
    assert_difference('Course.count') do
      post courses_url, params: { course: { code: @course.code, contents: @course.contents, ects: @course.ects, examination: @course.examination, literature: @course.literature, methods: @course.methods, mission: @course.mission, name: @course.name, objectives: @course.objectives, prerequisites: @course.prerequisites, skills_general: @course.skills_general, skills_intellectual: @course.skills_intellectual, skills_knowledge_understanding: @course.skills_knowledge_understanding, skills_practical: @course.skills_practical } }
    end

    assert_redirected_to course_url(Course.last)
  end

  test "should show course" do
    get course_url(@course)
    assert_response :success
  end

  test "should get edit" do
    get edit_course_url(@course)
    assert_response :success
  end

  test "should update course" do
    patch course_url(@course), params: { course: { code: @course.code, contents: @course.contents, ects: @course.ects, examination: @course.examination, literature: @course.literature, methods: @course.methods, mission: @course.mission, name: @course.name, objectives: @course.objectives, prerequisites: @course.prerequisites, skills_general: @course.skills_general, skills_intellectual: @course.skills_intellectual, skills_knowledge_understanding: @course.skills_knowledge_understanding, skills_practical: @course.skills_practical } }
    assert_redirected_to course_url(@course)
  end

  test "should destroy course" do
    assert_difference('Course.count', -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end

  test "should export a course as json" do
    get export_course_json_url(id: @course.id)
    assert_response :success
    assert_includes response.body, @course.code
    assert_includes response.body, @course.name
  end

  test "should export all courses as json" do
    get export_courses_json_url
    assert_response :success
    assert_includes response.body, @course.code
    assert_includes response.body, @course.name
  end

  test "should import a course from json" do
    file = fixture_file_upload("#{Rails.root}/test/fixtures/files/2020-08-14_B1-Informatik1.json",'application/json')
    files_array = Array.new
    files_array << file
    post import_course_json_url, params: { files: files_array }
    assert_response :redirect
    assert_redirected_to course_url(Course.find_by(code: 'B1'))
  end

  test "should import courses from multiple json" do
    file1 = fixture_file_upload("#{Rails.root}/test/fixtures/files/2020-08-14_B1-Informatik1.json",'application/json')
    file2 = fixture_file_upload("#{Rails.root}/test/fixtures/files/2020-08-14_B7-Informatik2.json",'application/json')
    files_array = Array.new
    files_array << file1 << file2
    post import_course_json_url, params: { files: files_array }
    assert_response :redirect
    assert_redirected_to courses_url
  end
end
