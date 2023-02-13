
module SemesterTestHelper
  def create_semester
    visit semesters_path
    click_on 'New Semester'
    find(:select, 'new_semester_season').find("[value='Winter']").select_option
    find(:select, 'new_semester_year').find("[value='2023']").select_option

    find(:select, 'copy_semester_season').find("[value='Spring']").select_option
    find(:select, 'copy_semester_year').find("[value='2022']").select_option
    click_on 'Create Semester'
  end

end
