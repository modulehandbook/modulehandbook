class CreatePrograms < ActiveRecord::Migration[6.0]
  def change
    create_table :programs do |t|
      t.text :name
      t.text :code
      t.text :mission
      t.text :degree
      t.integer :ects

      t.timestamps
    end
  end
end
