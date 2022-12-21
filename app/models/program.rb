class Program < ApplicationRecord
  include CombinedVersioning
  include SemesterDataAdder

  has_many :course_programs, dependent: :destroy, :foreign_key => [:program_id, :program_valid_end]
  has_many :courses, through: :course_programs

  def select_name
    "#{name} (#{code})"
  end

  def select_name_with_semester
    "#{name} (#{code}) - #{get_semester_name(self[:valid_end])}"
  end

  def self.find_or_create_from_json(data)
    existing_program = Program.find_by(code: data['code'])
    program = if !existing_program.nil?
                existing_program
              else
                Program.new
              end
    program.name = data['name']
    program.code = data['code']
    program.mission = data['mission']
    program.degree = data['degree']
    program.ects = data['ects']
    program.save
    program
  end

  def self.json_import_from_file(file)
    data = JSON.parse(file.read)
    ProgramFactory.create(data)
  end

  def gather_data_for_json_export
    exclude_attributes = [:transaction_start, :transaction_end, :valid_end, :valid_start, :change_list, :author_id]
    data = as_json(except: exclude_attributes)
    data["semester_season"] = get_semester_season(valid_end)
    data["semester_year"] = get_semester_year(valid_end)

    courses = self.courses.order(:code).as_json(except: exclude_attributes)
    cp_links = course_programs
    courses.each do |course|
      cp_link = cp_links.where(course_id: course['id'], course_valid_end: course['valid_end'])
      cp_link.each do |link|
        course['semester'] = link.semester
        course['required'] = link.required
      end
    end
    data['courses'] = courses
    data = data.as_json
    data
  end
end

class ProgramFactory
  def self.create(data)
    program = Program.find_or_create_from_json(data)
    courses = data['courses']
    courses.each do |course_data|
      course = Course.find_or_create_from_json(course_data)
      cpl = CourseProgram.find_or_create_from_json(course_data, course.id, program.id)
      course.save
    end
    program
  end
end
