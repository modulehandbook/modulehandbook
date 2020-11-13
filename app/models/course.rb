class Course < ApplicationRecord
  has_many :course_programs, dependent: :destroy
  has_many :programs, through: :course_programs
  def select_name
    "#{name} (#{code})"
  end

  def self.find_or_create_from_json(data)
    existing_course = Course.find_by(code: data['code'])
    if !existing_course.nil?
      course = existing_course
    else
      course = Course.new
    end
    course.name = data['name']
    course.code = data['code']
    course.mission = data['mission']
    course.ects = data['ects']
    course.examination = data['examination']
    course.objectives = data['objectives']
    course.contents = data['contents']
    course.prerequisites = data['prerequisites']
    course.literature = data['literature']
    course.methods = data['methods']
    course.skills_knowledge_understanding = data['skills_knowledge_understanding']
    course.skills_intellectual = data['skills_intellectual']
    course.skills_practical = data['skills_practical']
    course.skills_general = data['skills_general']
    course.lectureHrs = data['lectureHrs']
    course.labHrs = data['labHrs']
    course.tutorialHrs = data['tutorialHrs']
    course.equipment = data['equipment']
    course.room = data['room']
    course.save
    course
  end

  def self.json_import_from_file(file, program_id_from_params)
    data = JSON.parse(file.read)
    CourseFactory.create(data, program_id_from_params)
  end

  def gather_data_for_json_export
    data = self.as_json
    programs = self.programs.order(:name).as_json
    cp_links = self.course_programs
    programs.each do |program|
      cp_link = cp_links.where(program_id: program['id'])
      cp_link.each do |link|
        program['semester'] = link.semester
        program['required'] = link.required
      end
    end
    data['programs'] = programs
    data = data.as_json
    data
  end
end

class CourseFactory
  def self.create(data, program_id_from_params)
    course = Course.find_or_create_from_json(data)
    course_program = CourseProgram.find_or_create_from_json(data, course.id, program_id_from_params) unless program_id_from_params.nil?
    course.save
    programs = data['programs']
    programs.each do |program_data|
      program = Program.find_or_create_from_json(program_data)
      course_program = CourseProgram.find_or_create_from_json(program_data, course.id, program.id)
      course.save
    end
    course
  end
end
