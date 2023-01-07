
module CourseVersionsTestHelper
  def create_version(responsible_person:, ects:)
    assert_text "Course:"
    click_on 'Edit'
    fill_in 'course_responsible_person', with: responsible_person
    fill_in 'course_ects', with: ects
    click_on 'Update Course'
    assert_text 'Course was successfully updated.'
  end

  def can_create_version
    visit course_path(@course)
    create_version(responsible_person: 'Me', ects: '2')
    click_on 'See Course Versions'
    assert_text 'Version History of'
    assert_text 'Updated ects: 1 -> 2'
  end

  def can_see_versions
    visit course_path(@course)
    create_version(responsible_person: 'Me', ects: '2')
    click_on 'See Course Versions'
    assert_text 'Version History of'
    assert_text 'Updated ects: 1 -> 2'
  end

  def can_revert_version
    visit course_path(@course)
    create_version(responsible_person: 'Me', ects: '2')
    create_version(responsible_person: 'Not Me', ects: '5')
    click_on 'See Course Versions'
    assert_text 'Version History of'
    click_on 'Revert to this Version', match: :first
    refute_text 'Not Me'
    assert_text 'Me'
  end

end