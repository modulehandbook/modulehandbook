# frozen_string_literal: true

module Abilities
  # defines abilities for editors
  # Editor:innen haben die selben Rechte wie die Writer. Zusätzlich dazu können sie für das Modul oder den Studiengang, für welches sie als Editor eingetragen sind, den Status ändern. Studiengangs-Editor:innen können die Status alle Module ändern, die zu ihrem Studiengang gehören, Modul-Editor:innen nur für das entsprechende Modul.
  class Editor
    include CanCan::Ability

    def initialize(_user)
      alias_action :create, :read, :update, :delete, :destroy, to: :crud
      alias_action :export_course_json, :export_courses_json, to: :export_course
      alias_action :export_program_json, :export_programs_json, :export_program_docx, to: :export_program
      alias_action :import_course_json, to: :import_course
      alias_action :import_program_json, to: :import_program

      can %i[crud], CourseProgram
      can %i[crud export_course import_course], Course
      can %i[crud export_program import_program], Program
      can %i[read], User
    end
  end
end
