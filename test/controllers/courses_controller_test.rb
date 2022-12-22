require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
   
  setup do
    @course = courses(:one)
    sign_in users(:one)
  end

  test 'should get index' do
    get courses_url
    assert_response :success
  end

  test 'should get new' do
    get new_course_url
    assert_response :success
  end

  test 'should create course' do
    assert_difference('Course.count') do
      post courses_url, params: { course: { code: @course.code, contents: @course.contents, ects: @course.ects, examination: @course.examination, literature: @course.literature, methods: @course.methods, mission: @course.mission, name: @course.name, objectives: @course.objectives, prerequisites: @course.prerequisites, skills_general: @course.skills_general, skills_intellectual: @course.skills_intellectual, skills_knowledge_understanding: @course.skills_knowledge_understanding, skills_practical: @course.skills_practical } }
    end

    assert_equal Course.last.aasm_state, 'in_progress'
    assert_redirected_to course_url(Course.last)
  end

  test 'should show course' do
    get course_url(@course)
    assert_response :success
  end

  test 'should get edit' do
    get edit_course_url(@course)
    assert_response :success
  end

  test 'should update course' do
    patch course_url(@course), params: { course: { code: @course.code, contents: @course.contents, ects: @course.ects, examination: @course.examination, literature: @course.literature, methods: @course.methods, mission: @course.mission, name: @course.name, objectives: @course.objectives, prerequisites: @course.prerequisites, skills_general: @course.skills_general, skills_intellectual: @course.skills_intellectual, skills_knowledge_understanding: @course.skills_knowledge_understanding, skills_practical: @course.skills_practical } }
    assert_redirected_to course_url(@course)
  end

  test 'should destroy course' do
    assert_difference('Course.count', -1) do
      delete course_url(@course)
    end

    assert_redirected_to courses_url
  end
end
