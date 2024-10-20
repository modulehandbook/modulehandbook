# frozen_string_literal: true

json.extract! course_program, :id, :course_id, :program_id, :semester, :required, :created_at, :updated_at
json.url course_program_url(course_program, format: :json)
