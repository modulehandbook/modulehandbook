require 'application_system_test_case'

class VersionsAdminTest < ApplicationSystemTestCase
  def setup
    @course = courses(:one)
    @user = users(:one)
    @user_other = users(:writer)
    system_test_login(@user.email, 'geheim12')
  end

  test 'as admin i can revert to a version of a comment' do
    visit course_path(@course)
    create_version(responsible_person: 'Me', ects: '2')
    create_version(responsible_person: 'Not Me', ects: '5')
    click_on 'See Course Versions'
    assert_text 'Version History of'
    click_on 'Revert to this Version'
    refute_text 'Not Me'
    assert_text 'Me'
  end
end
