require 'test_helper'

class ProgramsControllerImportExportTest < ActionDispatch::IntegrationTest
   
  setup do
    @program = programs(:one)
    sign_in users(:one)
  end

  test 'should export a program as json' do
    get export_program_json_url(id: @program.id.to_s)
    assert_response :success
    assert_includes response.body, @program.code
    assert_includes response.body, @program.name
  end

  test 'should export all programs as json' do
    get export_programs_json_url(:current_semester_season => "Winter", :current_semester_year => 2021)
    assert_response :success
    assert_includes response.body, @program.code
    assert_includes response.body, @program.name
  end

  test 'should import a program from json' do
    file = fixture_file_upload("#{Rails.root}/test/fixtures/files/2022-12-23_IMI-B-InternationaleMedieninformatik_Spring 2022.json", 'application/json')
    files_array = []
    files_array << file
    post import_program_json_url, params: { files: files_array }
    assert_response :redirect
    assert_redirected_to program_url(Program.find_by(code: 'IMI-B', valid_end: "2022-06-30"))
  end

  test 'should import programs from multiple json' do
    file1 = fixture_file_upload("#{Rails.root}/test/fixtures/files/2022-12-23_IMI-B-InternationaleMedieninformatik_Spring 2022.json", 'application/json')
    file2 = fixture_file_upload("#{Rails.root}/test/fixtures/files/2022-12-23_IMI-B-InternationaleMedieninformatik_Winter 2021.json", 'application/json')
    files_array = []
    files_array << file1 << file2
    post import_program_json_url, params: { files: files_array }
    assert_response :redirect
    assert_redirected_to programs_url
  end
end
