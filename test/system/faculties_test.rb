# frozen_string_literal: true

require 'application_system_test_case'

class FacultiesTest < ApplicationSystemTestCase
  setup do
    @faculty = faculties(:one)
    @user = users(:one)
    system_test_login(@user.email, 'geheim12')
  end

  test 'visiting the index' do
    visit faculties_url
    assert_selector 'h3', text: 'Faculties'
  end

  test 'should create faculty' do
    visit faculties_url
    click_on 'New faculty'

    fill_in 'Description', with: @faculty.description
    fill_in 'Name', with: @faculty.name
    fill_in 'Url', with: @faculty.url
    click_on 'Create Faculty'

    assert_text 'Faculty was successfully created'
    click_on 'Back'
  end

  test 'should update Faculty' do
    visit faculty_url(@faculty)
    click_on 'Edit this faculty', match: :first

    fill_in 'Description', with: @faculty.description
    fill_in 'Name', with: @faculty.name
    fill_in 'Url', with: @faculty.url
    click_on 'Update Faculty'

    assert_text 'Faculty was successfully updated'
    click_on 'Back'
  end

  test 'should destroy Faculty' do
    visit faculty_url(@faculty)
    click_on 'Destroy this faculty', match: :first

    assert_text 'Faculty was successfully destroyed'
  end
end
