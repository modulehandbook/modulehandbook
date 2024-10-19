class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def to_s
    inspect
  end
end
