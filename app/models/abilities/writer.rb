# frozen_string_literal: true

module Abilities
  # defines abilities for writers
  # Autor:innen (Writer) können Modulbeschreibungen sowie Studiengänge editieren, die Versionsgeschichte einsehen und Änderungen rückgängig machen. Sie können jedoch nicht den Status der Modulbeschreibungen oder des Studiengangs verändern.
  class Writer
    include CanCan::Ability

    def initialize(_user)
      can %i[crud versions], CourseProgram
      can %i[crud export_course import_course versions], Course
      can %i[crud export_program import_program versions], Program
    end
  end
end
# post 'change_state', to: 'courses#change_state'
# post 'change_state', to: 'courses#change_state'
