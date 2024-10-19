# frozen_string_literal: true

# see https://github.com/CanCanCommunity/cancancan/blob/develop/docs/README.md
class Ability
  include CanCan::Ability
  include Abilities

  def initialize(user)
    aliases

    not_logged_in_abilities(user)
    return if user.blank?

    raise("non-existent user role #{user.role}") unless User::ROLES.include?(user.role.to_sym)

     method_name = "#{user.role}_abilities"
    self.send(method_name, user)
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

  def not_logged_in_abilities(user);end
  def reader_abilities(user)
    not_logged_in_abilities(user)
    can %i[read update], User, id: user.id
    can %i[read], User, readable: true
    can %i[read export_course], Course
    can %i[read export_program], Program
    can %i[read], Faculty
    can %i[read], CourseProgram
    reader_comment_abilities(user)
  end


  def reader_comment_abilities(user)
    can %i[read], Comment
    can %i[create], Comment
    can %i[destroy], Comment, author_id: user.id
    can %i[edit update], Comment, Comment do |comment|
      comment.author_id == user.id && comment.created_at >= 30.minutes.ago
    end
  end


  def writer_abilities(user)
    reader_abilities(user)
    can %i[crud], CourseProgram
    can %i[crud export_course import_course versions], Course
    can %i[crud export_program import_program], Program
  end

  def editor_abilities(user)
    writer_abilities(user)
    can %i[crud], CourseProgram
    can %i[create read update], Faculty
    can %i[crud export_course import_course change_state revert_to], Course
    can %i[crud export_program import_program], Program
    can %i[read approve], User
  end
  def qa_abilities(user)
    editor_abilities(user)
  end

  def admin_abilities(user)
    qa_abilities(user)
    can :manage, :all
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
