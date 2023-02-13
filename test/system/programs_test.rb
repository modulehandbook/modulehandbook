require 'application_system_test_case'

class ProgramsTest < ApplicationSystemTestCase
  setup do
    @program = programs(:one)
    @user = users(:one)
    system_test_login(@user.email, 'geheim12')
  end

  test 'visiting the index' do
    visit programs_url
    assert_selector 'h3', text: 'Programs'
  end

  test 'creating a Program' do
    visit programs_url
    click_on 'New Program'

    fill_in 'Code', with: @program.code
    fill_in 'Degree', with: @program.degree
    fill_in 'Ects', with: @program.ects
    fill_in 'Mission', with: @program.mission
    fill_in 'Name', with: @program.name
    click_on 'Create Program'

    assert_text 'Program was successfully created'
    click_on 'Back to Index'
  end

  test 'updating a Program' do
    visit programs_url
    click_on 'Edit', match: :first

    fill_in 'Code', with: @program.code
    fill_in 'Degree', with: @program.degree
    fill_in 'Ects', with: @program.ects
    fill_in 'Mission', with: @program.mission
    fill_in 'Name', with: @program.name
    click_on 'Update Program'

    assert_text 'Program was successfully updated'
    click_on 'Back'
  end

  test 'destroying a Program' do
    visit programs_url
    sleep(1)

    @program = programs(:one_spring)
    page.accept_confirm do
      click_on "destroy_program_#{@program.id}"
    end

    assert_text 'Program was successfully destroyed'
    assert !Program.exists?(@program.id)
  end

  test 'selecting semester in index' do
    visit programs_url
    find(:select, 'current_semester_season').find("[value='Winter']").select_option
    find(:select, 'current_semester_year').find("[value='2021']").select_option
    click_on "Show", match: :first

    assert_current_path "/programs?current_semester_season=Winter&current_semester_year=2021&commit=Show"
  end

  test 'showing correct semester based on params in index' do
    visit programs_url(params: { current_semester_season: "Winter", current_semester_year: 2021 })
    assert_equal "Winter", find(:select, 'current_semester_season').find('option[selected]').text
    assert_equal "2021", find(:select, 'current_semester_year').find('option[selected]').text
  end

  test 'showing correct as of time based on params in index' do
    time = (Time.zone.now + 1.second).strftime('%Y-%m-%dT%H:%M:%S')
    visit programs_url(params: { as_of_time: time})
    assert_equal time, find_field('as_of_time').value
  end

  test 'selecting semester in program' do
    visit program_url(@program)
    find(:select, 'current_semester_season').find("[value='Winter']").select_option
    find(:select, 'current_semester_year').find("[value='2021']").select_option
    click_on "Show", match: :first

    assert_current_path "/programs/#{@program.id}?current_semester_season=Winter&current_semester_year=2021&commit=Show"
  end

  test 'showing correct semester based on params in program' do
    visit program_url(@program, params: { current_semester_season: "Winter", current_semester_year: 2021 })
    assert_equal "Winter", find(:select, 'current_semester_season').find('option[selected]').text
    assert_equal "2021", find(:select, 'current_semester_year').find('option[selected]').text
  end

  test 'showing correct as of time based on params in program' do
    time = (Time.zone.now + 1.second).strftime('%Y-%m-%dT%H:%M:%S')
    visit program_url(@program, params: { as_of_time: time})
    assert_equal time, find_field('as_of_time').value
  end
end
