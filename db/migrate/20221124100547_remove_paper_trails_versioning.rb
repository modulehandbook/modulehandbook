class RemovePaperTrailsVersioning < ActiveRecord::Migration[7.0]
  def change
    drop_table :versions
  end
end
