# frozen_string_literal: true

json.array! @topic_descriptions, partial: 'topic_descriptions/topic_description', as: :topic_description
