class UpdateCourseProgramsForeignKeys < ActiveRecord::Migration[7.0]
  def change
    add_column :course_programs, :course_valid_end, :date, null: false
    add_column :course_programs, :program_valid_end, :date, null: false

    add_index :courses, :valid_end
    add_index :programs, :valid_end

    add_foreign_key :course_programs, :courses, column: :course_valid_end, primary_key: :valid_end, type: :date
    add_foreign_key :course_programs, :programs, column: :program_valid_end, primary_key: :valid_end, type: :date
  end

end
