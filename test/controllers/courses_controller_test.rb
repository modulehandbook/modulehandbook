require 'test_helper'

class CoursesControllerTest < ActionDispatch::IntegrationTest
   
  setup do
    @course = courses(:one)
    @course_spring = courses(:one_spring)
    sign_in users(:one)
  end

  test 'should get index' do
    get courses_url
    assert_response :success
  end

  test 'should get index when provided as of time before the current time' do
    get courses_url(params: { as_of_time: (Time.zone.now - 1.hour).to_s })
    assert_response :success
  end

  test 'should redirect to courses when "Reset" parameter' do
    get courses_url(params: { commit: "Reset" })
    assert_redirected_to courses_url
  end

  test 'should get versions' do
    get course_versions_url(@course)
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

  # Sleeps for 2 seconds then sets as of time to 1 second ago
  test 'should show course when provided as of time before the current time' do
    sleep 2
    get course_url(@course, params: { as_of_time: (Time.zone.now - 1.second).to_s })
    assert_response :success
  end

  test 'should redirect without as of time when course does not exist at provided as of time' do
    get course_url(@course, params: { as_of_time: (Time.now - 40.year).to_s })
    assert_redirected_to course_url(@course)
  end

  test 'should redirect to correct semester path to match parameters' do
    get course_url(@course, params: { current_semester_season: "Spring", current_semester_year: 2022 })
    assert_redirected_to course_url(@course_spring)
  end

  test 'should redirect to course when "Reset" parameter' do
    get course_url(@course, params: { commit: "Reset" })
    assert_redirected_to course_url(@course)
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
