class CourseProgram < ApplicationRecord
  belongs_to :course, :foreign_key => [:course_id, :course_valid_end]
  belongs_to :program, :foreign_key => [:program_id, :program_valid_end]

  validate :course_and_program_linkable

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

  private

  def course_and_program_linkable
    unless self[:course_valid_end] == self[:program_valid_end]
      errors.add(:course_valid_end, message: "must match program_valid_end (same semester)")
      errors.add(:program_valid_end, message: "must match course_valid_end (same semester)")
    end
  end
end
