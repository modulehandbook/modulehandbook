class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def to_s
    self.inspect
  end
end
