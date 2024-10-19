require 'test_helper'

class ProgramsControllerImportExportTest < ActionDispatch::IntegrationTest
  setup do
    @program = programs(:one)
    sign_in users(:one)
  end

  test 'should export a program as json' do
    get export_program_json_url(id: @program.id)
    assert_response :success
    assert_includes response.body, @program.code
    assert_includes response.body, @program.name
  end

  test 'should export all programs as json' do
    get export_programs_json_url
    assert_response :success
    assert_includes response.body, @program.code
    assert_includes response.body, @program.name
  end

  test 'should import a program from json' do
    file = fixture_file_upload(
      "#{Rails.root.join('test/fixtures/files/2020-08-14_IMI-B-InternationaleMedieninformatik.json')}", 'application/json'
    )
    files_array = []
    files_array << file
    post import_program_json_url, params: { files: files_array }
    assert_response :redirect
    assert_redirected_to program_url(Program.find_by(code: 'IMI-B'))
  end

  test 'should import programs from multiple json' do
    file1 = fixture_file_upload(
      "#{Rails.root.join('test/fixtures/files/2020-08-14_IMI-B-InternationaleMedieninformatik.json')}", 'application/json'
    )
    file2 = fixture_file_upload(
      "#{Rails.root.join('test/fixtures/files/2020-08-14_IMI-B-InternationaleMedieninformatik2.json')}", 'application/json'
    )
    files_array = []
    files_array << file1 << file2
    post import_program_json_url, params: { files: files_array }
    assert_response :redirect
    assert_redirected_to programs_url
  end

  test 'should import additional courses to program' do
    program = programs(:imib)
    file1 = fixture_file_upload("#{Rails.root.join('test/fixtures/files/two_courses.json')}", 'application/json')
    post program_add_courses_url(id: program.id), params: { files: [file1] }
    assert_response :redirect
    assert_redirected_to program_url(id: program.id)
    assert program.courses.size >= 2
  end

  test 'updates existing course in program on import' do
    program = programs(:imi1c)
    file_name = "#{Rails.root.join('test/fixtures/files/two_courses.json')}"
    file1 = fixture_file_upload(file_name, 'application/json')
    post program_add_courses_url(id: program.id), params: { files: [file1] }
    assert_response :redirect
    assert_redirected_to program_url(id: program.id)
    updated_course = program.courses.find_by(code: 'B7')
    assert_equal 'Mission for Info2', updated_course.mission
  end

  test 'allowed fields for import' do
    program = programs(:imi1c)
    file_name = "#{Rails.root.join('test/fixtures/files/two_courses.json')}"
    file1 = fixture_file_upload(file_name, 'application/json')
    post program_add_courses_url(id: program.id), params: { files: [file1] }
    assert_response :redirect
    assert_redirected_to program_url(id: program.id)
    updated_course = program.courses.find_by(code: 'B7')
    assert_equal 'Barne Kleinen', updated_course.teacher
  end

  test 'should import additional courses to program - codes only need to be unique for program' do
    program1 = programs(:imib)
    program2 = programs(:imib2)
    file1 = fixture_file_upload("#{Rails.root.join('test/fixtures/files/two_courses.json')}", 'application/json')
    post program_add_courses_url(id: program1.id), params: { files: [file1] }
    post program_add_courses_url(id: program2.id), params: { files: [file1] }
    assert_response :redirect
    assert_redirected_to program_url(id: program2.id)
    assert program1.courses.size >= 2
    assert program2.courses.size >= 2
    b7_1 = program1.courses.where(code: 'B7').first
    b7_2 = program2.courses.where(code: 'B7').first
    b7_1.name = 'changed'
    assert_not_equal b7_1.name, b7_2.name
  end

  test 'adds semester to link on import' do
    program = programs(:imib)
    file_name = "#{Rails.root.join('test/fixtures/files/with_semester.json')}"
    file1 = fixture_file_upload(file_name, 'application/json')
    post program_add_courses_url(id: program.id), params: { files: [file1] }
    assert_response :redirect
    assert_redirected_to program_url(id: program.id)
    updated_course = program.courses.find_by(code: 'WT2')
    course_program = program.course_programs.find_by(course_id: updated_course.id)
    assert_equal 5, course_program.semester
    assert_equal 'elective', course_program.required
  end
end
