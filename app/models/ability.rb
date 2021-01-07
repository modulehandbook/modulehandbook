# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # The following aliases are added by default for conveniently mapping common controller actions.
    # alias_action :index, :show, :to => :read
    # alias_action :new, :to => :create
    # alias_action :edit, :to => :update
    alias_action :create, :read, :update, :delete, :destroy, to: :crud
    alias_action :export_course_json, :export_courses_json, to: :export_course
    alias_action :export_program_json, :export_programs_json, :export_program_docx, to: :export_program
    alias_action :import_course_json, to: :import_course
    alias_action :import_program_json, to: :import_program

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
