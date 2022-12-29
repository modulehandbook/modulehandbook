class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  check_authorization unless: :devise_controller?
  before_action :set_author


  def set_author
    system_versioning_set_author(current_user)
  end

  rescue_from CanCan::AccessDenied do |exception|
      respond_to do |format|
        format.json { head :forbidden }
        format.html { redirect_to root_path, alert: exception.message }
      end
    end
end
