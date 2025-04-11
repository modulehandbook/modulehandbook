class AddCommentToTopic < ActiveRecord::Migration[8.0]
  def change
    add_column :topics, :comment, :text
  end
end
