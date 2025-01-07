# frozen_string_literal: true

json.array! @topics, partial: 'topics/topic', as: :topic
