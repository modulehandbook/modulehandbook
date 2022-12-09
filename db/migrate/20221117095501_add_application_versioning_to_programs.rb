class AddApplicationVersioningToPrograms < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      ALTER TABLE programs
        ADD COLUMN valid_start DATE,
        ADD COLUMN valid_end DATE,
        ADD PERIOD FOR p(valid_start,valid_end),
        DROP PRIMARY KEY,
        ADD PRIMARY KEY(id, valid_end)
    SQL
  end

end
