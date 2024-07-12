class AddTeacherToCourses < ActiveRecord::Migration[7.0]
  def change
    add_column :courses, :teacher, :string
  end
end
