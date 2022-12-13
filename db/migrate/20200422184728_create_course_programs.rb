class CreateCoursePrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :course_programs do |t|
      t.references :course, null: false, foreign_key: true
      t.references :program, null: false, foreign_key: true
      t.integer :semester
      t.text :required
    end
  end
end
