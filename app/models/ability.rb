# frozen_string_literal: true

# see https://github.com/CanCanCommunity/cancancan/blob/develop/docs/README.md
class Ability
  include CanCan::Ability
  include Abilities

  def initialize(user)
    aliases

    #not_logged_in_abilities(user)
    return if user.blank?

    raise("non-existent user role #{user.role}") unless User::ROLES.include?(user.role.to_sym)

    User::ROLES.each do | user_role |# ROLES = %i[reader writer editor qa admin].freeze
      method_name = "#{user_role}_abilities"
      self.send(method_name, user)
      return if user.role == user_role
    end
      merge Abilities::Reader.new(user)
    return if user.role == 'reader'

    # return unless user.role == 'writer' || user.role == 'editor' || user.role == 'qa' || user.role == 'admin'

    merge Abilities::Writer.new(user)
    return if user.role == 'writer'

    # return unless user.role == 'editor' || user.role == 'qa' || user.role == 'admin'
    role = 'editor'
    method_name = "#{role}_abilities"
    self.send(method_name, user)
    #editor_abilities(user)
    #merge Abilities::Editor.new(user)
    return if user.role == 'editor'

    # return unless user.role == 'qa' || user.role == 'admin'

    merge Abilities::Qa.new(user)
    return unless user.role == 'admin'

    merge Abilities::Admin.new(user)
  end

  def aliases
    # The following aliases are added by default for conveniently mapping common controller actions.
    # alias_action :index, :show, :to => :read
    # alias_action :new, :to => :create
    # alias_action :edit, :to => :update
    alias_action :create, :read, :update, :delete, :destroy, to: :crud
    alias_action :export_course_json, :export_courses_json, :export_course_docx, to: :export_course
    alias_action :export_program_json, :export_programs_json, :export_program_docx, to: :export_program
    alias_action :import_course_json, to: :import_course
    alias_action :import_program_json, to: :import_program
  end

  def self.list_actions_by_module
    ability_classes = [Abilities::All, Abilities::Reader, Abilities::Writer, Abilities::Editor, Abilities::Qa,
                       Abilities::Admin]
    alias_expansion = { crud: %i[create read update delete destroy] }

    # Default actions available for all models
    default_actions = %i[create read update destroy delete]

    actions_by_module = Hash.new { |hash, key| hash[key] = [] }

    # Get possible actions for all modules based on roles
    ability_classes.each do |ability_class|
      instance = ability_class.new(User.new)
      rules = instance.__send__(:rules)

      rules.each do |rule|
        actions = rule.actions.flat_map { |action| alias_expansion.fetch(action, [action]) }
        rule.subjects.each do |subject|
          actions_by_module[subject.name] += actions
        end
      end
    end

    actions_by_module.each do |module_name, actions|
      actions_by_module[module_name] = default_actions + actions
    end

    # Remove duplicate actions
    actions_by_module.transform_values(&:uniq)
  end
end
