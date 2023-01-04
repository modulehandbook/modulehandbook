require 'test_helper'

class SemestersControllerTest < ActionDispatch::IntegrationTest

  setup do
    sign_in users(:one)
  end

  test 'should get index' do
    get semesters_url
    assert_response :success
  end

  test 'should generate new semester' do
    assert_difference('Program.count',2) do
      post semester_generate_url, params: { new_semester_season: "Winter", new_semester_year: 2023, copy_semester_season: "Spring", copy_semester_year: 2022  }
    end

    assert_equal Program.last.valid_end.to_s, '2024-01-31' # Valid end of Winter 2023
    assert_redirected_to semesters_url
  end

  test 'should update existing semester when generate called on existing semester' do
    assert_difference('Program.count', 0) do
      post semester_generate_url, params: { new_semester_season: "Spring", new_semester_year: 2022, copy_semester_season: "Winter", copy_semester_year: 2021  }
    end

    assert_equal Program.last.valid_end.to_s, '2022-06-30' # Last updated program should be in Spring 2022
    assert_redirected_to semesters_url
  end

  test 'should redirect to new semester when copy semester not valid' do
    post semester_generate_url, params: { new_semester_season: "Winter", new_semester_year: 2023, copy_semester_season: "Spring", copy_semester_year: 2025  }

    assert_redirected_to new_semester_url
  end

end
