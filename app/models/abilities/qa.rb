# frozen_string_literal: true

module Abilities
  # defines abilities for QAs (Quality Assurance)
  # Mitarbeiter:innen der Qualitätssicherung (QAs) können alles, was die Editor:innen können. Aber sie werden von niemandem explizit in ein Modul oder einen Studiengang eingetragen, sondern haben mit ihrer Rolle Zugriff auf alle Module und Studiengänge
  class Qa
    include CanCan::Ability

    def initialize(_user)
      can %i[create read update delete], CourseProgram
      can %i[create read update delete], Course
      can %i[create read update delete], Program
      can %i[read update], User
    end
  end
end