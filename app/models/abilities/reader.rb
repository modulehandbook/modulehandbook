# frozen_string_literal: true

module Abilities
  # defines abilities for editors
  #
  class Reader
    include CanCan::Ability

    def initialize(_user)
      can :read, :all
      can %i[read export_course], Course
      can %i[read export_program], Program
      can %i[create], Comment
      can %i[update destroy], Comment, author_id: _user.id
    end
  end
end
