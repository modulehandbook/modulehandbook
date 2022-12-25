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
end
