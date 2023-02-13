json.extract! @comment, :author_id, :comment, :course_id
json.url comment_url(@comment, format: :json)
