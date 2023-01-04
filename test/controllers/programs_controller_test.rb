require 'test_helper'

class ProgramsControllerTest < ActionDispatch::IntegrationTest
   
  setup do
    @program = programs(:one)
    @program_spring = programs(:one_spring)
    sign_in users(:one)
  end

  test 'should get index' do
    get programs_url
    assert_response :success
  end

  test 'should get index when provided as of time before the current time' do
    get programs_url(params: { as_of_time: (Time.zone.now - 1.hour).to_s })
    assert_response :success
  end

  test 'should redirect to programs when "Reset" parameter' do
    get programs_url(params: { commit: "Reset" })
    assert_redirected_to programs_url
  end

  test 'should get versions' do
    get program_versions_url(@program)
    assert_response :success
  end

  test 'should get new' do
    get new_program_url
    assert_response :success
  end

  test 'should create program' do
    assert_difference('Program.count') do
      post programs_url, params: { program: { code: @program.code, degree: @program.degree, ects: @program.ects, mission: @program.mission, name: @program.name } }
    end

    assert_redirected_to program_url(Program.last)
  end

  test 'should show program' do
    get program_url(@program)
    assert_response :success
  end

  # Sleeps for 2 seconds then sets as of time to 1 second ago
  test 'should show program when provided as of time before the current time' do
    sleep 2
    get program_url(@program, params: { as_of_time: (Time.zone.now - 1.second).to_s })
    assert_response :success
  end

  test 'should redirect without as of time when program does not exist at provided as of time' do
    get program_url(@program, params: { as_of_time: (Time.now - 40.year).to_s })
    assert_redirected_to program_url(@program)
  end

  test 'should redirect to correct semester path to match parameters' do
    get program_url(@program, params: { current_semester_season: "Spring", current_semester_year: 2022 })
    assert_redirected_to program_url(@program_spring)
  end

  test 'should redirect to program when "Reset" parameter' do
    get program_url(@program, params: { commit: "Reset" })
    assert_redirected_to program_url(@program)
  end

  test 'should get edit' do
    get edit_program_url(@program)
    assert_response :success
  end

  test 'should update program' do
    patch program_url(@program), params: { program: { code: @program.code, degree: @program.degree, ects: @program.ects, mission: @program.mission, name: @program.name } }
    assert_redirected_to program_url(@program)
  end

  test 'should destroy program' do
    assert_difference('Program.count', -1) do
      delete program_url(@program)
    end

    assert_redirected_to programs_url
  end
end
