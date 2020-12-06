class AddAasmStateToCourses < ActiveRecord::Migration[6.0]
  def change
    add_column :courses, :aasm_state, :string
  end
end
