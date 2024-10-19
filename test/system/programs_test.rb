# frozen_string_literal: true

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

    @program = programs(:one)
    page.accept_confirm do
      click_on "destroy_program_#{@program.id}"
    end

    assert_text 'Program was successfully destroyed'
    assert !Program.exists?(@program.id)
  end
end
