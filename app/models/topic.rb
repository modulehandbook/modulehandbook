
class Topic < ApplicationRecord
  has_paper_trail
  has_many :topic_descriptions, dependent: :destroy
  accepts_nested_attributes_for :topic_descriptions
end
