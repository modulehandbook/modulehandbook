class AddHoursToCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :lectureHrs, :decimal
    add_column :courses, :labHrs, :decimal
    add_column :courses, :tutorialHrs, :decimal
  end
end
