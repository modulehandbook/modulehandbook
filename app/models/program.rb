# frozen_string_literal: true

class Program < ApplicationRecord
  has_many :course_programs, dependent: :destroy
  has_many :courses, through: :course_programs
  has_many :comments, as: :commentable
  has_many :topic_descriptions, as: :implementable, dependent: :destroy
  has_many :topics, through: :topic_descriptions
  has_paper_trail

  scope :study_plan, -> { where.not(required: 'elective-option') }
  scope :elective_options, -> { where(required: 'elective-option') }

  EDITABLE_ATTRIBUTES = %i[name code mission degree ects].freeze
  def select_name
    "#{name} (#{code})"
  end

  def self.find_or_create_from_json(data)
    existing_program = Program.find_by(code: data['code'])
    program = if existing_program.nil?
                Program.new
              else
                existing_program
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
    data = as_json
    courses = self.courses.order(:code).as_json
    cp_links = course_programs
    courses.each do |course|
      cp_link = cp_links.where(course_id: course['id'])
      cp_link.each do |link|
        course['semester'] = link.semester
        course['required'] = link.required
      end
    end
    data['courses'] = courses
    data.as_json
  end

  def shallow_copy
    json_01 = as_json
    # json_02 = gather_data_for_json_export
    params = json_01.slice(*EDITABLE_ATTRIBUTES.map(&:to_s))
    program_copy = Program.create!(params)
    course_programs.each do |cp|
      program_copy.course_programs.create(
        course: cp.course,
        required: cp.required,
        semester: cp.semester
      )
    end
    program_copy
  end

  def create_copy
    @program = self
    parameters = ActionController::Parameters.new(@program.attributes).permit(ProgramsController::PERMITTED_PARAMS)
    @program_copy = Program.build(parameters)
    @program_copy.code = @program.code+"-copy"
    @program_copy.name = @program.name+" (Copy)"

    cps = @program.course_programs
    cps.each do |cp|
      cp_attributes = ActionController::Parameters.new(cp.attributes).permit(CourseProgramsController::PERMITTED_PARAMS)
      cp_attributes.delete(:program_id)
      @program_copy.course_programs << CourseProgram.build(cp_attributes)
    end
    @program_copy
  end

end

class ProgramFactory
  def self.create(data)
    program = Program.find_or_create_from_json(data)
    courses = data['courses']
    courses.each do |course_data|
      course = Course.find_or_create_from_json(course_data)
      CourseProgram.find_or_create_from_json(course_data, course.id, program.id)
      course.save
    end
    program
  end
end
