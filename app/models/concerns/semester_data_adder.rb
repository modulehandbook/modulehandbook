
module SemesterDataAdder
  extend ActiveSupport::Concern
  include VersioningHelper

  included do
    attr_accessor :semester_season, :semester_year
    before_create :add_semester_data

    private
    def add_semester_data
      self.valid_end = get_valid_end_from_season_and_year(semester_season, semester_year.to_i)
      self.valid_start = get_valid_start_from_valid_end(self.valid_end)
    end

  end

end
