class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  check_authorization unless: :devise_or_active_admin_controller?
end
