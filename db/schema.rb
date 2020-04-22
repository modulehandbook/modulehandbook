# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_22_184210) do

  create_table "courses", force: :cascade do |t|
    t.text "name"
    t.text "code"
    t.text "mission"
    t.integer "ects"
    t.text "examination"
    t.text "objectives"
    t.text "contents"
    t.text "prerequisites"
    t.text "literature"
    t.text "methods"
    t.text "skills_knowledge_understanding"
    t.text "skills_intellectual"
    t.text "skills_practical"
    t.text "skills_general"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "programs", force: :cascade do |t|
    t.text "name"
    t.text "code"
    t.text "mission"
    t.text "degree"
    t.integer "ects"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
