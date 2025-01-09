# frozen_string_literal: true

# superclass for all Model classes in App
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  self.abstract_class = true

  def to_s
    inspect
  end
end
