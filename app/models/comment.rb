class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :course, :foreign_key => [:course_id, :course_valid_end]
end
