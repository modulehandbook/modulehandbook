module ApplicationVersioning
  extend ActiveSupport::Concern

  included do
    self.primary_key = :id, :valid_end
  end

  class_methods do

  end

end