class AddIndexToCoursePrograms < ActiveRecord::Migration[7.1]
  def change
    add_index(:course_programs, [:course_id, :program_id], unique: true)
  end
end