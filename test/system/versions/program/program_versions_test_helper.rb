
module ProgramVersionsTestHelper
  def create_version(mission:, ects:)
    assert_text "Courses in Program"
    click_on 'Edit'
    fill_in 'program_mission', with: mission
    fill_in 'program_ects', with: ects
    click_on 'Update Program'
    assert_text 'Program was successfully updated.'
  end

  def can_create_version
    visit program_path(@program)
    create_version(mission: 'Mission', ects: '2')
    click_on 'See Program Versions'
    assert_text 'Version History of'
    assert_text 'Updated ects: 1 -> 2'
  end

  def can_see_versions
    visit program_path(@program)
    create_version(mission: 'Mission', ects: '2')
    click_on 'See Program Versions'
    assert_text 'Version History of'
    assert_text 'Updated ects: 1 -> 2'
  end

  def can_revert_version
    visit program_path(@program)
    create_version(mission: 'OldM', ects: '2')
    create_version(mission: 'NewM', ects: '5')
    click_on 'See Program Versions'
    assert_text 'Version History of'
    click_on 'Revert to this Version', match: :first
    refute_text 'NewM'
  end

end