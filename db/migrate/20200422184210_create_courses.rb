class CreateCourses < ActiveRecord::Migration[6.0]
  def change
    create_table :courses do |t|
      t.text :name
      t.text :code
      t.text :mission
      t.integer :ects
      t.text :examination
      t.text :objectives
      t.text :contents
      t.text :prerequisites
      t.text :literature
      t.text :methods
      t.text :skills_knowledge_understanding
      t.text :skills_intellectual
      t.text :skills_practical
      t.text :skills_general
    end
  end
end
