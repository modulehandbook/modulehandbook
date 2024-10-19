# frozen_string_literal: true

class CourseProgram < ApplicationRecord
  belongs_to :course
  belongs_to :program

  # validates :course_id, uniqueness: { scope: %i[program_id] }

  scope :study_plan, -> { where.not(required: 'elective-option') }
  scope :elective_options, -> { where(required: 'elective-option') }
  def self.find_or_create_from_json(data, course_id, program_id)
    cpl = CourseProgram.find_by(course_id: course_id, program_id: program_id)
    if cpl.nil?
      cpl = CourseProgram.new(course_id: course_id,
                              program_id: program_id,
                              semester: data['semester'],
                              required: data['required'])
    end
    cpl.save
    cpl
  end

  def copy
    CourseProgram.new(as_json)
  end
end
