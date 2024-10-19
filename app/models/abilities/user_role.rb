# frozen_string_literal: true

module Abilities
  # abstract superclass for all user role abilities
  class UserRole
    include CanCan::Ability
    def initialize(_user)

    end
  end
end
