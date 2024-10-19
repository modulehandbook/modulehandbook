# frozen_string_literal: true

module Abilities
  include CanCan::Ability

  def editor_abilities(_user)
    can %i[crud], CourseProgram
    can %i[create read update], Faculty
    can %i[crud export_course import_course change_state revert_to], Course
    can %i[crud export_program import_program], Program
    can %i[read approve], User
  end

  def reader_abilities(user)
    can %i[read update], User, id: user.id
    can %i[read], User, readable: true
    can %i[read export_course], Course
    can %i[read export_program], Program
    can %i[read], Faculty
    can %i[read], CourseProgram
    user_comment_abilities(user)
  end

  def reader_comment_abilities(user)
    can %i[read], Comment
    can %i[create], Comment
    can %i[destroy], Comment, author_id: user.id
    can %i[edit update], Comment, Comment do |comment|
      comment.author_id == user.id && comment.created_at >= 30.minutes.ago
    end
  end

  def writer_abilities(_user)
    can %i[crud], CourseProgram
    can %i[crud export_course import_course versions], Course
    can %i[crud export_program import_program], Program
  end

  def not_logged_in_abilities(user); end
end
# defines abilities without login
