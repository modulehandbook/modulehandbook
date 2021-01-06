# frozen_string_literal: true

module Abilities
  # defines abilities for QAs (Quality Assurance)
  # Mitarbeiter:innen der Qualitätssicherung (QAs) können alles, was die Editor:innen können. Aber sie werden von niemandem explizit in ein Modul oder einen Studiengang eingetragen, sondern haben mit ihrer Rolle Zugriff auf alle Module und Studiengänge
  class Qa
    include CanCan::Ability

    def initialize(_user)
      can %i[create read update delete destroy], CourseProgram
      can %i[create read update delete destroy export_course_json export_courses_json import_course_json], Course
      can %i[create read update delete destroy export_program_json export_programs_json export_program_docx import_program_json], Program
      can %i[read], User
    end
  end
end
