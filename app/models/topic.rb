# frozen_string_literal: true

# Topics describe cross-cutting topics
# for a program. This model holds the
# normalized Title for Topics
class Topic < ApplicationRecord
  has_paper_trail
  has_many :topic_descriptions, dependent: :destroy
end
