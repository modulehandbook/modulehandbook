# frozen_string_literal: true

# superclass for all Model classes in App
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def to_s
    inspect
  end
end
