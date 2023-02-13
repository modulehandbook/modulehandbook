class AddSystemVersioningToCoursePrograms < ActiveRecord::Migration[7.0]

  def change
    add_column :course_programs, :change_list, :text
    add_column :course_programs, :author_id, :bigint
    add_foreign_key :course_programs, :users, column: :author_id, primary_key: :id

    execute <<-SQL
      ALTER TABLE course_programs
        ADD COLUMN transaction_start TIMESTAMP(6) GENERATED ALWAYS AS ROW START,
        ADD COLUMN transaction_end TIMESTAMP(6) GENERATED ALWAYS AS ROW END,
        ADD PERIOD FOR SYSTEM_TIME(transaction_start, transaction_end),
        ADD SYSTEM VERSIONING;
    SQL
  end

end
