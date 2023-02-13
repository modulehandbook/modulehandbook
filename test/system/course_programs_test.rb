require 'application_system_test_case'

class CourseProgramsTest < ApplicationSystemTestCase
  setup do
    @course_program = course_programs(:one)
    @course_spring = courses(:one_spring)
    @program_spring = programs(:one_spring)
    @user = users(:one)
    system_test_login(@user.email, 'geheim12')
  end


  test 'visiting the index' do
    visit course_programs_url
    assert_selector 'h3', text: 'Course-Program Links'
  end

  test 'creating a Course program' do
    visit course_programs_url
    click_on 'New Course Program'

    find(:select, 'Course').find("[value='#{@course_spring.id.to_s}']").select_option
    find(:select, 'Program').find("[value='#{@program_spring.id.to_s}']").select_option
    select @course_program.required, from: 'Required'
    fill_in 'Semester', with: @course_program.semester
    click_on 'Create Course program'

    assert_text 'Course program was successfully created'
  end

  test 'updating a Course program' do
    visit course_programs_url
    click_on 'Edit', match: :first

    find(:select, 'Course').find("[value='#{@course_program.course.id.to_s}']").select_option
    find(:select, 'Program').find("[value='#{@course_program.program.id.to_s}']").select_option
    select @course_program.required, from: 'Required'
    fill_in 'Semester', with: @course_program.semester
    click_on 'Update Course program'

    assert_text 'Course program was successfully updated'
  end

  test 'destroying a Course program' do
    visit course_programs_url
    sleep(1)

    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Course program was successfully destroyed'
  end

  test 'selecting semester in index' do
    visit course_programs_url
    find(:select, 'current_semester_season').find("[value='Winter']").select_option
    find(:select, 'current_semester_year').find("[value='2021']").select_option
    click_on "Show", match: :first

    assert_current_path "/course_programs?current_semester_season=Winter&current_semester_year=2021&commit=Show"
  end

  test 'showing correct semester based on params in index' do
    visit course_programs_url(params: { current_semester_season: "Winter", current_semester_year: 2021 })
    assert_equal "Winter", find(:select, 'current_semester_season').find('option[selected]').text
    assert_equal "2021", find(:select, 'current_semester_year').find('option[selected]').text
  end

  test 'showing correct as of time based on params in index' do
    time = (Time.zone.now + 1.second).strftime('%Y-%m-%dT%H:%M:%S')
    visit course_programs_url(params: { as_of_time: time})
    assert_equal time, find_field('as_of_time').value
  end

  test 'showing correct as of time based on params in course program' do
    time = (Time.zone.now + 1.second).strftime('%Y-%m-%dT%H:%M:%S')
    visit course_program_url(@course_program, params: { as_of_time: time})
    assert_equal time, find_field('as_of_time').value
  end
end
