class TopicDescription < ApplicationRecord
  has_paper_trail
  belongs_to :topic
  belongs_to :implementable, polymorphic: true
end
