class AddFieldsToCourse < ActiveRecord::Migration[8.0]
  def change
    add_column :courses, :specialization, :text
    add_column :courses, :responsible_person_email, :string
  end
end
