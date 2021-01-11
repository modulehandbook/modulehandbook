# frozen_string_literal: true

module Abilities
  # defines abilities for writers
  # Autor:innen (Writer) können Modulbeschreibungen sowie Studiengänge editieren, die Versionsgeschichte einsehen und Änderungen rückgängig machen. Sie können jedoch nicht den Status der Modulbeschreibungen oder des Studiengangs verändern.
  class Writer
    include CanCan::Ability

    def initialize(_user)
      can %i[crud], CourseProgram
      can %i[crud export_course import_course trigger_event], Course
      can %i[crud export_program import_program], Program
      can %i[read], User
    end
  end
end
# post 'trigger_event', to: 'courses#trigger_event'
# post 'trigger_event', to: 'courses#trigger_event'
