# frozen_string_literal: true

# Topics describe cross-cutting topics
# for a program. This model holds the
# normalized Title for Topics
class Topic < ApplicationRecord
  has_paper_trail
  has_many :topic_descriptions, dependent: :destroy
  has_many :implementables, through: :topic_descriptions, as: :implementable

  accepts_nested_attributes_for :topic_descriptions

  def programs
    tds = topic_descriptions.where(implementable_type: Program)
    tds.map(&:implementable)
  end

  def courses(program)
    tds = topic_descriptions.where(implementable_type: Course, topic: self)
    courses = tds.map(&:implementable)
    program.courses - courses
  end
end
