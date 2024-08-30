# frozen_string_literal: true

module Abilities
  # defines abilities without login
  class All
    include CanCan::Ability
    def initialize(_user)
     
    end
  end
end
