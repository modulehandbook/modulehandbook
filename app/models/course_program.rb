class CourseProgram < ApplicationRecord
  include MariaDBTemporalTables::SystemVersioning

  belongs_to :course, :foreign_key => [:course_id, :course_valid_end]
  belongs_to :program, :foreign_key => [:program_id, :program_valid_end]

  validate :course_and_program_linkable
  validate :unique_course_program_combination, on: :create

  def self.find_or_create_from_json(data, course_id, program_id, course_valid_end, program_valid_end)
    cpl = CourseProgram.find_by(course_id: course_id, program_id: program_id, course_valid_end: course_valid_end, program_valid_end: program_valid_end )
    if cpl.nil?
      cpl = CourseProgram.new(course_id: course_id,
                              program_id: program_id,
                              course_valid_end: course_valid_end,
                              program_valid_end: program_valid_end,
                              semester: data['semester'],
                              required: data['required'])
    end
    cpl.save
    cpl
  end

  private

  def course_and_program_linkable
    unless self[:course_valid_end] == self[:program_valid_end]
      errors.add(:base, message: "Course and program must be in the same semester to be linked")
    end
  end

  def unique_course_program_combination
    if self.class.exists?(
      :course_id => self[:course_id],
      :program_id => self[:program_id],
      :course_valid_end => self[:course_valid_end],
      :program_valid_end => self[:program_valid_end]
    )

      errors.add(:base, message: "Link with same course and program already exists")
    end

  end
end
