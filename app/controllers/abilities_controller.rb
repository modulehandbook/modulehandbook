class AbilitiesController < ApplicationController
  load_and_authorize_resource
  def index
    #@controller = all_controllers
    #@models = [Course, Program, CourseProgram, Comment, Faculty, Version, User]
      @roles = User::ROLES
    # @actions_by_controller = actions_by_controller
      @actions_by_model = actions_by_model
      @models = @actions_by_model.keys.sort_by(&:to_s)
      @abilities = @roles.map { |r| [r, Ability.new(User.new(role: r))] }.to_h
  end
  def actions_by_controller

    actions_by_controller = Hash.new { |hash, key| hash[key] = [] }

    all_controllers.each do |controller|
      controller_routes = all_routes.select { |r| r[:controller] == controller }
      actions = controller_routes.map { |r| r[:action] }.uniq.sort
      actions_by_controller[controller] = actions
    end
    actions_by_controller
  end

  def all_controllers
    controllers = all_routes.map { |r| r[:controller] }.uniq.sort
  end

  def all_routes
    routes = Rails.application.routes.routes.map(&:defaults)
    routes.reject! { |r| r[:controller].nil? }
    reject = ['action_mailbox', 'active_storage', 'devise', 'rails', 'turbo']
    reject.each do |controller_prefix |
      routes.reject! { |r| r[:controller].starts_with? controller_prefix }
    end
    routes

  end

  def actions_by_model
    actions_by_model = Hash.new { |hash, key| hash[key] = [] }
    ability = Ability.new(User.new(role: 'admin'))
    alias_expansion = ability.aliased_actions
    # { crud: %i[create read update delete destroy] }
    rules = ability.__send__(:rules)
    rules.each do |rule|
        actions = rule.actions.flat_map { |action| alias_expansion.fetch(action, [action]) }
        rule.subjects.each do |subject|
          actions_by_model[subject] += actions
        end
    end
    actions_by_model = actions_by_model.transform_values(&:uniq)
    actions_by_model
  end
end
