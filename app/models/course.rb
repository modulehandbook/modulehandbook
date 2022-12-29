class Course < ApplicationRecord
  include AASM
  include MariaDBTemporalTables::CombinedVersioning
  include SemesterDataAdder

  has_many :comments, :foreign_key => [:course_id, :course_valid_end]

  aasm whiny_transitions: :false do
    state :in_progress, initial: true
    state :in_review
    state :ready_for_councils
    state :updating
    state :done

    event :finish_writing do
      transitions from: :in_progress, to: :in_review
    end
    event :no_changes_required do
      transitions from: :in_review, to: :ready_for_councils
    end
    event :changes_required do
      transitions from: :in_review, to: :in_progress
      transitions from: :ready_for_councils, to: :in_progress
    end
    event :decisions_complete do
      transitions from: :ready_for_councils, to: :done, guard: :only_term_info_edied?
      transitions from: :ready_for_councils, to: :updating
    end
    event :start_update do
      transitions from: :done, to: :updating
    end
    event :finish_updating do
      transitions from: :updating, to: :done, guard: :only_term_info_edied?
      transitions from: :updating, to: :in_progress
    end
    event :reset_state do
      transitions to: :in_progress
    end
  end

  def only_term_info_edied?
    true
  end

  def possible_events
    aasm.permitted_transitions.map(&:event)
  end

  has_many :course_programs, dependent: :destroy, :foreign_key => [:course_id, :course_valid_end]
  has_many :programs, through: :course_programs

  def select_name
    "#{name} (#{code})"
  end

  def select_name_with_semester
    "#{name} (#{code}) - #{get_semester_name(self[:valid_end])}"
  end

  def self.find_or_create_from_json(data, valid_start, valid_end)
    existing_course = Course.find_by(code: data['code'], valid_end: valid_end)
    course = if !existing_course.nil?
               existing_course
             else
               existing_course_no_semester = Course.find_by(code: data['code']) # Find existing disregarding semester
               Course.new(:id => existing_course_no_semester && existing_course_no_semester[:id])
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
    course.valid_start = valid_start
    course.valid_end = valid_end
    course.save
    course
  end

  def self.json_import_from_file(file, program_id_from_params)
    data = JSON.parse(file.read)
    course_instance = Course.new #required to use methods of VersioningHelper
    semester_season = data["semester_season"]
    semester_year = data["semester_year"]

    if !semester_season.nil? && !semester_year.nil?
      data["valid_end"] = course_instance.get_valid_end_from_season_and_year(semester_season, semester_year)
      data["valid_start"] = course_instance.get_valid_start_from_valid_end(data["valid_end"])
    else
      raise "Missing semester_season and/or semester_year"
    end

    if program_id_from_params.nil?
      CourseFactory.create(data, nil, nil)
    else
      split = course_instance.split_to_id_and_valid_end(program_id_from_params)
      CourseFactory.create(data, split[0], split[1])
    end
  end

  def gather_data_for_json_export
    exclude_attributes = [:transaction_start, :transaction_end, :valid_end, :valid_start, :change_list, :author_id]

    data = as_json(except: exclude_attributes)
    data["semester_season"] = get_semester_season(valid_end)
    data["semester_year"] = get_semester_year(valid_end)

    programs = self.programs.order(:name).as_json(except: exclude_attributes)
    cp_links = course_programs
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
  def self.create(data, program_id_from_params, program_valid_end_from_params)
    course = Course.find_or_create_from_json(data, data["valid_start"], data["valid_end"])
    unless program_id_from_params.nil?
      course_program = CourseProgram.find_or_create_from_json(data, course[:id], program_id_from_params, data["valid_end"], program_valid_end_from_params)
    end
    course.save
    programs = data['programs']
    programs.each do |program_data|
      program = Program.find_or_create_from_json(program_data, data["valid_start"], data["valid_end"])
      course_program = CourseProgram.find_or_create_from_json(program_data, course[:id], program[:id], data["valid_end"], data["valid_end"])
      course.save
    end
    course
  end
end
