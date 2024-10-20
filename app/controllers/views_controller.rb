# frozen_string_literal: true

class ViewsController < ApplicationController
  load_and_authorize_resource
  def index
    @courses = Version.accessible_by.order(:created_at)
  end
end
