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

  test 'should create course_program' do
    assert_difference('CourseProgram.count') do
      post course_programs_url, params: { course_program: { course_id: @course_program.course_id,
                                                            course_valid_end: '2022-06-30', #different valid_end since duplicates are not allowed
                                                            program_id: @course_program.program_id,
                                                            program_valid_end: '2022-06-30',
                                                            required: @course_program.required,
                                                            semester: @course_program.semester } }
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
    patch course_program_url(@course_program), params: { course_program: { course_id: @course_program.course_id,
                                                                           course_valid_end: @course_program.course_valid_end,
                                                                           program_id: @course_program.program_id,
                                                                           program_valid_end: @course_program.program_valid_end,
                                                                           required: @course_program.required,
                                                                           semester: @course_program.semester } }
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
