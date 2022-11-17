class CreateCoursePrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :course_programs do |t|
      t.bigint :course_id, null: false
      t.references :program, null: false, foreign_key: true
      t.integer :semester
      t.text :required

      t.timestamps
    end
    add_foreign_key :course_programs, :courses, column: :course_id, primary_key: :id
  end
end
