# frozen_string_literal: true

module Abilities
  # defines abilities without login
  class All
    include CanCan::Ability
  end
end
