class AddDepartmentToCourses < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :department, :text
  end
end
