# frozen_string_literal: true

# New Model Class to sort programs in Facultys
class Faculty < ApplicationRecord
  has_many :users, dependent: :nullify
end
