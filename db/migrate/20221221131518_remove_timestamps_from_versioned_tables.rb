class RemoveTimestampsFromVersionedTables < ActiveRecord::Migration[7.0]
  def change
    remove_timestamps :courses
    remove_timestamps :programs
    remove_timestamps :course_programs
  end
end
