class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.references :author, null: false
      t.text :comment
      t.references :commentable, null: false, polymorphic: true

      t.timestamps
    end
  end
end
