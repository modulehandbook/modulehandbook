# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_app_info
  before_action :set_back_to_path
  check_authorization unless: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden }
      format.html { redirect_to root_path, alert: exception.message }
    end
  end

  private

  def set_app_info
    @mh_app_name = ENV['MODULE_HANDBOOK_INSTANCE'] || 'Module Handbook'
    @mh_app_version = ENV['TAG_MODULE_HANDBOOK'] || 'unknown'
  end

  def set_back_to_path
    @back_to_path = params[:back_to]
  end

end
