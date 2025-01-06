# frozen_string_literal: true

# one Course within a Program - Modulbeschreibung
class Course < ApplicationRecord
  include AASM
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :topic_descriptions, as: :implementable, dependent: :destroy
  has_many :topics, through: :topic_descriptions
  has_paper_trail

  # rubocop:disable Metrics/BlockLength
  aasm whiny_transitions: false do
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
      transitions from: :ready_for_councils, to: :done, guard: :only_term_info_edited?
      transitions from: :ready_for_councils, to: :updating
    end
    event :start_update do
      transitions from: :done, to: :updating
    end
    event :finish_updating do
      transitions from: :updating, to: :done, guard: :only_term_info_edited?
      transitions from: :updating, to: :in_progress
    end
    event :reset_state do
      transitions to: :in_progress
    end
  end
  # rubocop:enable Metrics/BlockLength

  def only_term_info_edited?
    true
  end

  def possible_events
    aasm.permitted_transitions.map(&:event)
  end

  def accept_event(event_name)
    all_events = Course.aasm.events.map { |e| e.name }
    return unless all_events.include?(event_name.to_sym)

    event = "#{event_name}!"
    self.send(event.to_sym)
  end

  has_many :course_programs, dependent: :destroy
  has_many :programs, through: :course_programs

  def select_name
    "#{name} (#{code})"
  end

  def self.find_or_create_from_json(data)
    course_code = data['code']
    course = Course.where(code: course_code).first_or_create
    parameters = ActionController::Parameters.new(data).permit(CoursesController::PERMITTED_PARAMS)
    course.update(parameters)
    # course.name = data['name']
    # course.code = course_code
    # course.mission = data['mission']
    # course.ects = data['ects']
    # course.examination = data['examination']
    # course.objectives = data['objectives']
    # course.contents = data['contents']
    # course.prerequisites = data['prerequisites']
    # course.literature = data['literature']
    # course.methods = data['methods']
    # course.skills_knowledge_understanding = data['skills_knowledge_understanding']
    # course.skills_intellectual = data['skills_intellectual']
    # course.skills_practical = data['skills_practical']
    # course.skills_general = data['skills_general']
    # course.lectureHrs = data['lectureHrs']
    # course.labHrs = data['labHrs']
    # course.tutorialHrs = data['tutorialHrs']
    # course.equipment = data['equipment']
    # course.room = data['room']

    course.save
    course
  end

  def self.json_import_from_file(file, program_id_from_params)
    data = JSON.parse(file.read)
    CourseFactory.create(data, program_id_from_params)
  end

  def gather_data_for_json_export
    data = as_json(only: CoursesController::PERMITTED_PARAMS)
    programs = self.programs.order(:name).as_json
    cp_links = course_programs
    programs.each do |program|
      cp_link = cp_links.where(program_id: program['id'])
      cp_link.each do |link|
        program['semester'] = link.semester
        program['required'] = link.required
      end
    end
    data['programs'] = programs
    data.as_json
  end
end

class CourseFactory
  def self.create(data, program_id_from_params)
    course = Course.find_or_create_from_json(data)
    unless program_id_from_params == :no_program_id
      CourseProgram.find_or_create_from_json(data, course.id, program_id_from_params)
    end
    course.save
    programs = data['programs'] || []
    programs.each do |program_data|
      program = Program.find_or_create_from_json(program_data)
      CourseProgram.find_or_create_from_json(program_data, course.id, program.id)
      course.save
    end
    course
  end
end
