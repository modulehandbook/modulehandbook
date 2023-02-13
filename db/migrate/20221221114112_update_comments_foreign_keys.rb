class UpdateCommentsForeignKeys < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :commentable_type
    remove_column :comments, :commentable_id

    add_column :comments, :course_id, :bigint, null: false
    add_column :comments, :course_valid_end, :date, null: false

    add_foreign_key :comments, :courses, column: :course_id, primary_key: :id, type: :bigint, on_delete: :cascade
    add_foreign_key :comments, :courses, column: :course_valid_end, primary_key: :valid_end, type: :date, on_delete: :cascade
  end
end
