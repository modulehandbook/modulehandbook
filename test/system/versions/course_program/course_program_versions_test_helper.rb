
module CourseProgramVersionsTestHelper
  def create_version(semester:, required:)
    assert_text "Course and Program"
    click_on 'Edit'
    fill_in 'course_program_semester', with: semester
    find(:select, 'course_program_required').find("[value='#{required}']").select_option
    click_on 'Update Course program'
    assert_text 'Course program was successfully updated.'
  end

  def can_create_version
    visit course_program_path(@course_program)
    create_version(semester: 1, required: 'required')
    click_on 'See Course-Program Versions'
    assert_text 'Version History of'
    assert_text 'Updated required: mandatory -> required'
  end

  def can_see_versions
    visit course_program_path(@course_program)
    create_version(semester: 1, required: 'required')
    click_on 'See Course-Program Versions'
    assert_text 'Version History of'
    assert_text 'Updated required: mandatory -> required'
  end

  def can_revert_version
    visit course_program_path(@course_program)
    create_version(semester: 1, required: 'mandatory')
    create_version(semester: 2, required: 'elective')
    click_on 'See Course-Program Versions'
    assert_text 'Version History of'
    click_on 'Revert to this Version', match: :first
    refute_text 'elective'
    assert_text 'mandatory'
  end

end