class AbilitiesController < ApplicationController
  def index
      @models = [Course, Program, CourseProgram, Comment, Faculty, Version, User]
      @roles = User::ROLES
      @actions_by_module = list_actions_by_module
      @abilities = roles.map { |r| [r, Ability.new(User.new(role: r))] }.to_h
  end
  def list_actions_by_module
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
