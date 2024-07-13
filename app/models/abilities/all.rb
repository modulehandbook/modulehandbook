# frozen_string_literal: true

module Abilities
  # defines abilities without login
  class All
    include CanCan::Ability
    def initialize(_user)
      can %i[nudge], NudgeController
    end
  end
end
