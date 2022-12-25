class AddPrecisionToCourseHourColumns < ActiveRecord::Migration[7.0]
  def change
    change_column :courses, :lectureHrs, :decimal,precision: 10, scale: 1
    change_column :courses, :labHrs, :decimal,precision: 10, scale: 1
    change_column :courses, :tutorialHrs, :decimal,precision: 10, scale: 1
  end
end
