class AddSemesterTypeToCourses < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :semester_type, :text
  end
end
