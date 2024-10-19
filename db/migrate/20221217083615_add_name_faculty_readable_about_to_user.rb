# frozen_string_literal: true

class AddNameFacultyReadableAboutToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :full_name, :string
    add_reference :users, :faculty, null: true, foreign_key: true
    add_column :users, :readable, :boolean
    add_column :users, :about, :text
  end
end
