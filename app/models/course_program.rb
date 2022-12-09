class CourseProgram < ApplicationRecord
  belongs_to :course, :foreign_key => [:course_id, :course_valid_end]
  belongs_to :program, :foreign_key => [:program_id, :program_valid_end]

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
end
