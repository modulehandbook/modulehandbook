require "application_system_test_case"

class CoursesTest < ApplicationSystemTestCase
  setup do
    @course = courses(:one)
  end

  test "visiting the index" do
    visit courses_url
    assert_selector "h1", text: "Courses"
  end

  test "creating a Course" do
    visit courses_url
    click_on "New Course"

    fill_in "Code", with: @course.code
    fill_in "Contents", with: @course.contents
    fill_in "Ects", with: @course.ects
    fill_in "Examination", with: @course.examination
    fill_in "Literature", with: @course.literature
    fill_in "Methods", with: @course.methods
    fill_in "Mission", with: @course.mission
    fill_in "Name", with: @course.name
    fill_in "Objectives", with: @course.objectives
    fill_in "Prerequisites", with: @course.prerequisites
    fill_in "Skills general", with: @course.skills_general
    fill_in "Skills intellectual", with: @course.skills_intellectual
    fill_in "Skills knowledge understanding", with: @course.skills_knowledge_understanding
    fill_in "Skills practical", with: @course.skills_practical
    click_on "Create Course"

    assert_text "Course was successfully created"
    click_on "Back"
  end

  test "updating a Course" do
    visit courses_url
    click_on "Edit", match: :first

    fill_in "Code", with: @course.code
    fill_in "Contents", with: @course.contents
    fill_in "Ects", with: @course.ects
    fill_in "Examination", with: @course.examination
    fill_in "Literature", with: @course.literature
    fill_in "Methods", with: @course.methods
    fill_in "Mission", with: @course.mission
    fill_in "Name", with: @course.name
    fill_in "Objectives", with: @course.objectives
    fill_in "Prerequisites", with: @course.prerequisites
    fill_in "Skills general", with: @course.skills_general
    fill_in "Skills intellectual", with: @course.skills_intellectual
    fill_in "Skills knowledge understanding", with: @course.skills_knowledge_understanding
    fill_in "Skills practical", with: @course.skills_practical
    click_on "Update Course"

    assert_text "Course was successfully updated"
    click_on "Back"
  end

  test "updating a Course - new fields" do
    @course2 = courses(:two)
    visit courses_url
    click_on "Edit", match: :first

    fill_in "Code", with: @course.code
    fill_in "Contents", with: @course.contents
    fill_in "Ects", with: @course.ects
    fill_in "Examination", with: @course.examination
    fill_in "Literature", with: @course.literature
    fill_in "Methods", with: @course.methods
    fill_in "Mission", with: @course.mission
    fill_in "Name", with: @course.name
    fill_in "Objectives", with: @course.objectives
    fill_in "Prerequisites", with: @course.prerequisites
    fill_in "Skills general", with: @course.skills_general
    fill_in "Skills intellectual", with: @course.skills_intellectual
    fill_in "Skills knowledge understanding", with: @course.skills_knowledge_understanding
    fill_in "Skills practical", with: @course.skills_practical
    click_on "Update Course"

    assert_text "Course was successfully updated"
    click_on "Back"
  end

  test "destroying a Course" do
    visit courses_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Course was successfully destroyed"
  end
end
