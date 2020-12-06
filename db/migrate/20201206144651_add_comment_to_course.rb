class AddCommentToCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :comment, :text
  end
end
