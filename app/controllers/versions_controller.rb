# frozen_string_literal: true

class VersionsController < ApplicationController
  load_and_authorize_resource
  def index
    @courses = Version.accessible_by(current_ability).order(:created_at)
  end
end
