# frozen_string_literal: true

json.array! @course_programs, partial: 'course_programs/course_program', as: :course_program
