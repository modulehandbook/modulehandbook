# frozen_string_literal: true

require 'test_helper'

class CoursesControllerImportTest < ActionDispatch::IntegrationTest
  setup do
    @course = courses(:one)
    sign_in users(:one)
  end

  test 'should export a course as json' do
    get export_course_json_url(id: @course.id)
    assert_response :success
    assert_includes response.body, @course.code
    assert_includes response.body, @course.name
  end

  test 'should export all courses as json' do
    get export_courses_json_url
    assert_response :success
    assert_includes response.body, @course.code
    assert_includes response.body, @course.name
  end

  test 'should import a course from json' do
    file = fixture_file_upload(Rails.root.join('test/fixtures/files/2020-08-14_B1-Informatik1.json').to_s,
                               'application/json')
    files_array = []
    files_array << file
    post import_course_json_url, params: { files: files_array }
    assert_response :redirect
    assert_redirected_to course_url(Course.find_by(code: 'B1'))
  end


  test 'should set teacher and responsible person when importing from json' do
    file = fixture_file_upload(Rails.root.join('test/fixtures/files/2025-01-05_B1-Informatik1.json').to_s,
                               'application/json')
    files_array = []
    files_array << file
    post import_course_json_url, params: { files: files_array }
    assert_response :redirect
    imported_course = Course.find_by(code: 'IMI25-B1')
    assert_redirected_to course_url(imported_course)
    assert_equal "", imported_course.teacher
    assert_equal "", imported_course.responsible_person
    
  end

  test 'should import courses from multiple json' do
    file1 = fixture_file_upload(Rails.root.join('test/fixtures/files/2020-08-14_B1-Informatik1.json').to_s,
                                'application/json')
    file2 = fixture_file_upload(Rails.root.join('test/fixtures/files/2020-08-14_B7-Informatik2.json').to_s,
                                'application/json')
    files_array = []
    files_array << file1 << file2
    post import_course_json_url, params: { files: files_array }
    assert_response :redirect
    assert_redirected_to courses_url
  end
end
