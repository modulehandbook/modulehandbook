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
      can %i[create read update delete], CourseProgram
      can %i[create read update delete export_course_json export_courses_json import_course_json], Course
      can %i[create read update delete export_program_json export_programs_json export_program_docx import_program_json], Program
      can %i[read], User
    end
  end
end
# post 'trigger_event', to: 'courses#trigger_event'
# post 'trigger_event', to: 'courses#trigger_event'
