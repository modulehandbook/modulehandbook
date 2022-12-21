class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  check_authorization unless: :devise_controller?
  before_action :set_current_user

  # Sets the current user in a thread variable to be accessible by models
  # Used to assign the 'author' of model changes
  def set_current_user
    Thread.current[:current_user] = current_user
  end

  rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.json { head :forbidden }
        format.html { redirect_to root_path, alert: exception.message }
      end
    end
end
