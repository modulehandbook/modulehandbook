# frozen_string_literal: true

module Abilities
  # defines abilities for admins
  class Admin < UserRole
    include CanCan::Ability

    def initialize(user)
      super
      can :manage, :all
    end
  end
end
