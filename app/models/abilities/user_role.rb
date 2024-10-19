# frozen_string_literal: true

module Abilities
  # abstract superclass for all user role abilities
  class UserRole
    include CanCan::Ability

    # rubocop:disable Style/RedundantInitialize
    def initialize(user); end
    # rubocop:enable Style/RedundantInitialize
  end
end
