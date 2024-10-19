# frozen_string_literal: true

module Abilities
  # defines abilities for admins
  class Admin < UserRole
    include CanCan::Ability

    def initialize(_user)
      super(user)
      can :manage, :all
    end
  end
end
