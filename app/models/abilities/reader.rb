# frozen_string_literal: true

module Abilities
  # defines abilities for readers
  #
  class Reader < UserRole
    include CanCan::Ability

    def initialize(user)
      super
      can %i[read update], User, id: user.id
      can %i[read], User, readable: true
      can %i[read export_course], Course
      can %i[read export_program], Program
      can %i[read], Faculty
      can %i[read], CourseProgram
      comment_abilities(user)
    end

    def comment_abilities(user)
      can %i[read], Comment
      can %i[create], Comment
      can %i[destroy], Comment, author_id: user.id
      can %i[edit update], Comment, Comment do |comment|
        comment.author_id == user.id && comment.created_at >= 30.minutes.ago
      end
    end
  end
end
