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
      can %i[create read update delete], Course
      can %i[create read update delete], Program
      can %i[read update], User
    end
  end
end
