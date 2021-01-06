# frozen_string_literal: true

module Abilities
  # defines abilities for writers
  # Autor:innen (Writer) können Modulbeschreibungen sowie Studiengänge editieren, die Versionsgeschichte einsehen und Änderungen rückgängig machen. Sie können jedoch nicht den Status der Modulbeschreibungen oder des Studiengangs verändern.
  class Writer
    include CanCan::Ability

    def initialize(_user)
      # The following aliases are added by default for conveniently mapping common controller actions.
      # alias_action :index, :show, :to => :read
      # alias_action :new, :to => :create
      # alias_action :edit, :to => :update
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
# post 'trigger_event', to: 'courses#trigger_event'
# post 'trigger_event', to: 'courses#trigger_event'
