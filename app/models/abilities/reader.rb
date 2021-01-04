# frozen_string_literal: true

module Abilities
  # defines abilities for editors
  #
  class Reader
    include CanCan::Ability

    def initialize(_user)
      can :read, :all
      can %i[read export_course_json export_courses_json], Course
      can %i[read export_program_json export_programs_json export_program_docx], Program
    end
  end
end
