class AddCommentToTopicDescription < ActiveRecord::Migration[8.0]
  def change
    add_column :topic_descriptions, :comment, :text
  end
end
