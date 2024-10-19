# frozen_string_literal: true

class WelcomeController < ApplicationController
  skip_authorization_check
  skip_before_action :authenticate_user!
  def index; end
end
