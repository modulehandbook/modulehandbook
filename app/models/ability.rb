# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    merge Abilities::Writer.new(user)
    return unless user.editor? || user.qa? || user.admin?

    merge Abilities::Editor.new(user)
    return unless user.qa? || user.admin?

    merge Abilities::QA.new(user)
    return unless user.admin?

    merge Abilities::Admin.new(user)
  end
end
