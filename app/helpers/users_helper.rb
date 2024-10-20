# frozen_string_literal: true

module UsersHelper
  FIELD_TYPE = User.columns_hash.transform_keys(&:to_sym).transform_values(&:type)
  FIELD_TYPE[:faculty_name] = :string
  FIELD_TYPE[:versions_count] = :integer

  def field_type(field_name)
    FIELD_TYPE[field_name.to_sym]
  end

  def format_time(at)
    return '' if at.nil? || at == ''
    at.strftime('%d/%m/%y (%H:%M)')
  end

  def field_editable?(field_name, user)
    if field_name == :approved
      (user != current_user) && (can? :manage_access, user)
    elsif field_name == :role
      can? :manage_access, current_user
    else
      UserAttrs::EDITABLE.include?(field_name)
    end
  end

  def field_computed?(field_name)
    UserAttrs::COMPUTED.include?(field_name)
  end

  def get_actions_for_models
    Rails.application.eager_load!

    actions_by_module = {}
    controllers_ignore = ["DeviseController", "WelcomeController", "ViewsController"]
    # c.name.match("::") -> ignores Controllers in the Users and Devise modules (from Devise)
    # TBD: maybe a Whitelist of Controllers that should be included is better/more readable?
    controllers = ApplicationController.descendants.reject{|c| c.name.match("::") || controllers_ignore.include?(c.name)}

    controllers.each do |controller|
      defined_actions = controller.instance_methods(false).map(&:to_s)
      name = controller.name.demodulize.sub('Controller', '').singularize

      actions_by_module[name] = defined_actions
    end

    actions_by_module
  end
end
