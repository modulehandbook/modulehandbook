# frozen_string_literal: true

module Abilities
  # defines abilities for editors
  #
  class Reader
    include CanCan::Ability

    def initialize(_user)
      alias_action :export_course_json, :export_courses_json, to: :export_course
      alias_action :export_program_json, :export_programs_json, :export_program_docx, to: :export_program

      can :read, :all
      can %i[read export_course], Course
      can %i[read export_program], Program
    end
  end
end
