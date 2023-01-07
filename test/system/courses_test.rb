require 'application_system_test_case'

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
    @course2 = courses(:two)
    @course3 = courses(:three)
    @user = users(:one)
    system_test_login(@user.email, 'geheim12')
  end

  test 'visiting the index' do
    visit courses_url
    assert_selector 'h3', text: 'Courses'
  end

  test 'creating a Course' do
    visit courses_url
    click_on 'New Course'

    fill_in 'Code', with: 'new course code'
    fill_in 'Contents', with: @course.contents
    fill_in 'Ects', with: @course.ects
    fill_in 'Examination', with: @course.examination
    fill_in 'Literature', with: @course.literature
    fill_in 'Methods', with: @course.methods
    fill_in 'Mission', with: @course.mission
    fill_in 'Name', with: @course.name
    fill_in 'Objectives', with: @course.objectives
    fill_in 'Prerequisites', with: @course.prerequisites
    fill_in 'Skills general', with: @course.skills_general
    fill_in 'Skills intellectual', with: @course.skills_intellectual
    fill_in 'Skills knowledge understanding', with: @course.skills_knowledge_understanding
    fill_in 'Skills practical', with: @course.skills_practical
    click_on 'Create Course'

    assert_text 'Course was successfully created'
    click_on 'Back'
  end

  test 'updating a Course' do
    visit courses_url
    click_on 'Edit', match: :first

    fill_in 'Code', with: @course.code
    fill_in 'Contents', with: @course.contents
    fill_in 'Ects', with: @course.ects
    fill_in 'Examination', with: @course.examination
    fill_in 'Literature', with: @course.literature
    fill_in 'Methods', with: @course.methods
    fill_in 'Mission', with: @course.mission
    fill_in 'Name', with: @course.name
    fill_in 'Objectives', with: @course.objectives
    fill_in 'Prerequisites', with: @course.prerequisites
    fill_in 'Skills general', with: @course.skills_general
    fill_in 'Skills intellectual', with: @course.skills_intellectual
    fill_in 'Skills knowledge understanding', with: @course.skills_knowledge_understanding
    fill_in 'Skills practical', with: @course.skills_practical
    click_on 'Update Course'

    assert_text 'Course was successfully updated'
    click_on 'Back'
  end

  test 'updating a Course - lectureHrs' do
    visit edit_course_url(@course2)
    new_data = 3732.3
    fill_in('course_lectureHrs', with: new_data)
    click_on 'Update Course'
    assert_text 'Course was successfully updated'
    assert_text new_data
    course = Course.find(@course2.id)
    assert_equal(new_data, course.lectureHrs)
  end

  test 'updating a Course - labHrs' do
    visit edit_course_url(@course2)
    new_data = 58_293.3
    fill_in('course_labHrs', with: new_data)
    click_on 'Update Course'
    assert_text 'Course was successfully updated'
    assert_text new_data
    course = Course.find(@course2.id)
    assert_equal(new_data, course.labHrs)
  end

  test 'updating a Course - tutorialHrs' do
    visit edit_course_url(@course2)
    new_data = 782_347_823.3
    fill_in('course_tutorialHrs', with: new_data)
    click_on 'Update Course'
    assert_text 'Course was successfully updated'
    assert_text new_data
    course = Course.find(@course2.id)
    assert_equal(new_data, course.tutorialHrs)
  end

  test 'updating a Course - equipment' do
    visit edit_course_url(@course2)
    new_data = 'many computers'
    fill_in('course_equipment', with: new_data)
    click_on 'Update Course'
    assert_text 'Course was successfully updated'
    assert_text new_data
    course = Course.find(@course2.id)
    assert_equal(new_data, course.equipment)
  end

  test 'updating a Course - room' do
    visit edit_course_url(@course2)
    new_data = 'sunny room in bright colors'
    fill_in('course_room', with: new_data)
    click_on 'Update Course'
    assert_text 'Course was successfully updated'
    assert_text new_data
    course = Course.find(@course2.id)
    assert_equal(new_data, course.room)
  end

  test 'updating a Course - comment' do
    visit edit_course_url(@course3)
    assert_logged_in
    new_data = 'does need more editing'
    fill_in('course_comment', with: new_data)
    click_on 'Update Course'
    assert_text 'Course was successfully updated'
    assert_text new_data
    course = Course.find(@course3.id)
    assert_equal(new_data, course.comment)
  end

  test 'updating a Course - responsible_person' do
    visit edit_course_url(@course3)
    new_data = 'Prof. Dr. Barne Kleinen'
    fill_in('course_responsible_person', with: new_data)
    click_on 'Update Course'
    assert_text 'Course was successfully updated'
    assert_text new_data
    course = Course.find(@course3.id)
    assert_equal(new_data, course.responsible_person)
  end

  test 'destroying a Course' do
    visit courses_url
    sleep(1)

    page.accept_confirm do
      click_on 'Destroy', match: :first
    end

    assert_text 'Course was successfully destroyed'
  end

  test 'selecting semester in index' do
    visit courses_url
    find(:select, 'current_semester_season').find("[value='Winter']").select_option
    find(:select, 'current_semester_year').find("[value='2021']").select_option
    click_on "Show", match: :first

    assert_current_path "/courses?current_semester_season=Winter&current_semester_year=2021&commit=Show"
  end

  test 'showing correct semester based on params in index' do
    visit courses_url(params: { current_semester_season: "Winter", current_semester_year: 2021 })
    assert_equal "Winter", find(:select, 'current_semester_season').find('option[selected]').text
    assert_equal "2021", find(:select, 'current_semester_year').find('option[selected]').text
  end

  test 'showing correct as of time based on params in index' do
    time = (Time.zone.now + 1.second).strftime('%Y-%m-%dT%H:%M:%S')
    visit courses_url(params: { as_of_time: time})
    assert_equal time, find_field('as_of_time').value
  end

  test 'selecting semester in course' do
    visit course_url(@course)
    find(:select, 'current_semester_season').find("[value='Winter']").select_option
    find(:select, 'current_semester_year').find("[value='2021']").select_option
    click_on "Show", match: :first

    assert_current_path "/courses/#{@course.id}?current_semester_season=Winter&current_semester_year=2021&commit=Show"
  end

  test 'showing correct semester based on params in course' do
    visit course_url(@course, params: { current_semester_season: "Winter", current_semester_year: 2021 })
    assert_equal "Winter", find(:select, 'current_semester_season').find('option[selected]').text
    assert_equal "2021", find(:select, 'current_semester_year').find('option[selected]').text
  end

  test 'showing correct as of time based on params in course' do
    time = (Time.zone.now + 1.second).strftime('%Y-%m-%dT%H:%M:%S')
    visit course_url(@course, params: { as_of_time: time})
    assert_equal time, find_field('as_of_time').value
  end
end
