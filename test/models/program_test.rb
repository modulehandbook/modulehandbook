require 'test_helper'

class ProgramTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  # describe "find_or_create_from_json creates valid program" do

  test 'find_or_create_from_json creates valid program with all details provided' do
    program_json = JSON.parse('{
        "id": 1,
        "name": "Internationale Medieninformatik",
        "code": "IMI-B",
        "mission": null,
        "degree": "Bachelor",
        "ects": 180,
        "created_at": "2020-08-13T13:27:21.150Z",
        "updated_at": "2020-08-13T13:27:21.150Z",
        "courses": []
      }'.gsub('nil', 'null'))
    assert_difference('Program.count', 1) do
      program = Program.find_or_create_from_json(program_json, "2022-02-01", "2022-06-30")
      assert_equal program_json['code'], program.code
    end
  end

  test 'find_or_create_from_json creates valid program with not all details provided' do
    program_json = JSON.parse('{
        "name": "Internationale Medieninformatik",
        "code": "IMI-B"
      }')
    assert_difference('Program.count', 1) do
      program = Program.find_or_create_from_json(program_json, "2022-02-01", "2022-06-30")
      assert_equal program_json['code'], program.code
    end
  end
  # end
end
