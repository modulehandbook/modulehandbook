require 'application_system_test_case'

class CourseProgramsTest < ApplicationSystemTestCase
  setup do
    @course_program = course_programs(:one)
    @user = users(:one)
    system_test_login(@user.email, 'geheim12')
  end

  test 'visiting the index' do
    visit course_programs_url
    assert_selector 'h3', text: 'Course Programs'
  end

  test 'creating a Course program' do
    visit course_programs_url
    click_on 'New Course Program'

    fill_in 'Course', with: @course_program.course_id
    fill_in 'Program', with: @course_program.program_id
    fill_in 'Required', with: @course_program.required
    fill_in 'Semester', with: @course_program.semester
    click_on 'Create Course program'

    assert_text 'Course program was successfully created'
    click_on 'Back'
  end

  test 'updating a Course program' do
    visit course_programs_url
    click_on 'Edit', match: :first

    fill_in 'Course', with: @course_program.course_id
    fill_in 'Program', with: @course_program.program_id
    fill_in 'Required', with: @course_program.required
    fill_in 'Semester', with: @course_program.semester
    click_on 'Update Course program'

    assert_text 'Course program was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Course program' do
    visit course_programs_url
    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Course program was successfully destroyed'
  end
end
