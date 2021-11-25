require 'application_system_test_case'

class VersionsWriterTest < ApplicationSystemTestCase
  def setup
    @course = courses(:one)
    @user = users(:writer)
    @user_other = users(:reader)
    sign_in @user
  end

  def teardown
    sign_out @user
    CourseProgram.all.delete_all
    Program.all.delete_all
    Course.all.delete_all
    User.all.delete_all
  end

  def create_version(responsible_person:, ects:)
    click_on 'Edit'
    fill_in 'course_responsible_person', with: responsible_person
    fill_in 'course_ects', with: ects
    click_on 'Update Course'
    assert_text 'Course was successfully updated.'
  end

  test 'as writer i can create a version on a course' do
    visit course_path(@course)
    create_version(responsible_person: 'Me', ects: '2')
    click_on 'See Course Versions'
    assert_text 'Version History of'
    assert_text 'Changed'
  end

  test 'as writer i can see versions of a comment' do
    visit course_path(@course)
    create_version(responsible_person: 'Me', ects: '2')
    click_on 'See Course Versions'
    assert_text 'Version History of'
    assert_text 'Changed'
  end

  test 'as writer i can not revert to a version of a comment' do
    visit course_path(@course)
    create_version(responsible_person: 'Me', ects: '2')
    create_version(responsible_person: 'Not Me', ects: '5')
    click_on 'See Course Versions'
    assert_text 'Version History of'
    refute_text 'Revert to this Version'
  end
end
