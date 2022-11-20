class AddSystemVersioningToCourses < ActiveRecord::Migration[7.0]

  def change
    execute <<-SQL
      ALTER TABLE courses
        ADD COLUMN author_id BIGINT,
        ADD COLUMN change_list TEXT,
        ADD COLUMN transaction_start TIMESTAMP(6) GENERATED ALWAYS AS ROW START,
        ADD COLUMN transaction_end TIMESTAMP(6) GENERATED ALWAYS AS ROW END,
        ADD CONSTRAINT FOREIGN KEY (author_id) REFERENCES users(id),
        ADD PERIOD FOR SYSTEM_TIME(transaction_start, transaction_end),
        ADD SYSTEM VERSIONING;
    SQL
  end

end
