# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    merge Abilities::Reader.new(user)
    return unless user.role == 'writer' || user.role == 'editor' || user.role == 'qa' || user.role == 'admin'

    merge Abilities::Writer.new(user)
    return unless user.role == 'editor' || user.role == 'qa' || user.role == 'admin'

    merge Abilities::Editor.new(user)
    return unless user.role == 'qa' || user.role == 'admin'

    merge Abilities::Qa.new(user)
    return unless user.role == 'admin'

    merge Abilities::Admin.new(user)
  end
end
