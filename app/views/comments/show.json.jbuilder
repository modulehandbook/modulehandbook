json.extract! @comment, :author_id, :comment, :commentable_id, :commentable_type
json.url comment_url(@comment, format: :json)
