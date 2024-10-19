# frozen_string_literal: true

module Abilities
  # defines abilities without login
  class All < UserRole
    include CanCan::Ability
    def initialize(user)
      super(user)
    end
  end
end
