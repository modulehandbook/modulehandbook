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
    # this causes error with fixtures ("can't cast Class")
    #tds = topic_descriptions.where(implementable_type: Program)
    tds = topic_descriptions.select{|td| td.implementable.class == Program}.uniq
    programs = tds.map(&:implementable)
    programs
  end

  def courses
    #tds = topic_descriptions.where(implementable_type: Course, topic: self)
    tds = topic_descriptions.select{|td| td.implementable.class == Course}.uniq
    courses = tds.map(&:implementable)
    courses.sort_by!(&:code)
  end
end
