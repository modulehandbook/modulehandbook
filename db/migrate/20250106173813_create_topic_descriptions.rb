class CreateTopicDescriptions < ActiveRecord::Migration[7.1]
  def change
    create_table :topic_descriptions do |t|
      t.references :topic, null: false, foreign_key: true
      t.references :implementer, polymorphic: true, null: false
      t.text :description

      t.timestamps
    end
  end
end
