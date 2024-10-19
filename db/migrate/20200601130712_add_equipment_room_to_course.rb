# frozen_string_literal: true

class AddEquipmentRoomToCourse < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :equipment, :text
    add_column :courses, :room, :text
  end
end
