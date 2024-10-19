require 'test_helper'

class CourseProgramsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @course_program = course_programs(:one)
    sign_in users(:one)
  end

  test 'should get index' do
    get course_programs_url
    assert_response :success
  end

  test 'should get new' do
    get new_course_program_url
    assert_response :success
  end

  test 'should not create second link between the same course/program' do
    skip
    assert_difference('CourseProgram.count', 0, 'link already exists') do
      post course_programs_url,
           params: { course_program: { course_id: @course_program.course_id, program_id: @course_program.program_id,
                                       required: @course_program.required, semester: @course_program.semester } }
    end
    assert_response :success
    # tbd: error should be shown!
  end

  test 'should create course_program' do
    course = courses(:one)
    program = programs(:two)
    assert_not_includes program.courses, course, 'no prior link may exist'
    params = { course_id: course.id,
               program_id: program.id,
               required: @course_program.required,
               semester: @course_program.semester }
    assert_difference('CourseProgram.count') do
      post course_programs_url, params: { course_program: params }
    end

    assert_redirected_to course_program_url(CourseProgram.last)
  end

  test 'should show course_program' do
    get course_program_url(@course_program)
    assert_response :success
  end

  test 'should get edit' do
    get edit_course_program_url(@course_program)
    assert_response :success
  end

  test 'should update course_program' do
    patch course_program_url(@course_program),
          params: { course_program: { course_id: @course_program.course_id, program_id: @course_program.program_id,
                                      required: @course_program.required, semester: @course_program.semester } }
    assert_redirected_to course_program_url(@course_program)
  end

  test 'should destroy course_program' do
    program = @course_program.program
    assert_difference('CourseProgram.count', -1) do
      delete course_program_url(@course_program)
    end

    assert_redirected_to program_url(program)
  end
end
