# frozen_string_literal: true

class AddIndexToCoursePrograms < ActiveRecord::Migration[7.1]
  def change
    add_index(:course_programs, %i[course_id program_id], unique: true)
  end
end
