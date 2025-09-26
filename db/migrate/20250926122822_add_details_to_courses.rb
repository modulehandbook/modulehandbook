class AddDetailsToCourses < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :specialization, :text
    add_column :courses, :head_of_department, :text
    add_column :courses, :responsible_person_mail, :text
  end
end
