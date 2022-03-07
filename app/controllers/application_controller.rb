class ApplicationController < ActionController::Base
  before_action :set_locale
  before_action :authenticate_user!
  def set_locale
    I18n.locale = :ar
  end
  check_authorization unless: :devise_controller?
end
