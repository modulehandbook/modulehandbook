# frozen_string_literal: true

# Comments can be attached to Courses and Programs
class Comment < ApplicationRecord
  belongs_to :author, class_name: 'User'
  belongs_to :commentable, polymorphic: true
end
