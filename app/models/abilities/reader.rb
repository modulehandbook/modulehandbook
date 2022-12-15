# frozen_string_literal: true

module Abilities
  # defines abilities for readers
  #
  class Reader
    include CanCan::Ability

    def initialize(user)
      can :crud, User, id: user.id
      can %i[read export_course], Course
      can %i[read export_program], Program
      can %i[read], CourseProgram
      can %i[read], Comment
      can %i[create], Comment
      can %i[destroy], Comment, author_id: user.id
      can %i[edit update], Comment, Comment do |comment|
        comment.author_id == user.id && comment.created_at >= 30.minutes.ago
      end
    end
  end
end
