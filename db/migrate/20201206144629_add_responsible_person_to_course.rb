# frozen_string_literal: true

class AddResponsiblePersonToCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :responsible_person, :string
  end
end
