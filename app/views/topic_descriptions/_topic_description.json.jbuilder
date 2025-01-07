# frozen_string_literal: true

json.extract! topic_description, :id, :topic_id, :implementable_id, :implementable_type, :description, :created_at,
              :updated_at
json.url topic_description_url(topic_description, format: :json)
