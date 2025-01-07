# frozen_string_literal: true

# TopicDescriptions link Courses or Programs to Topics.
# They contain a brief text (description) that either
# explains a topic in context of a Program
# is part of the module description within a course
# detailing the courses' contribution to the topic
# (usually to be used for cross-cutting topics)
class TopicDescription < ApplicationRecord
  has_paper_trail
  belongs_to :topic
  belongs_to :implementable, polymorphic: true
end
