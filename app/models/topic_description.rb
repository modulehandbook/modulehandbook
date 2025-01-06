class TopicDescription < ApplicationRecord
  belongs_to :topic
  belongs_to :implementer, polymorphic: true
end
