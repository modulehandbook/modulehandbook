# frozen_string_literal: true

module Abilities
  # defines abilities for editors
  # Editor:innen haben die selben Rechte wie die Writer. Zusätzlich dazu können sie für das Modul oder den Studiengang, für welches sie als Editor eingetragen sind, den Status ändern. Studiengangs-Editor:innen können die Status alle Module ändern, die zu ihrem Studiengang gehören, Modul-Editor:innen nur für das entsprechende Modul.
  class Editor
    include CanCan::Ability

    def initialize(_user)
      can %i[crud revert_to], CourseProgram
      can %i[create read update], Faculty
      can %i[crud export_course import_course change_state revert_to], Course
      can %i[crud export_program import_program revert_to], Program
      can %i[read approve], User
    end
  end
end
