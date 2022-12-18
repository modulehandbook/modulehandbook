# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_12_17_083615) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "author_id", null: false
    t.text "comment"
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_comments_on_author_id"
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
  end

  create_table "course_programs", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.bigint "program_id", null: false
    t.integer "semester"
    t.text "required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_programs_on_course_id"
    t.index ["program_id"], name: "index_course_programs_on_program_id"
  end

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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "lectureHrs"
    t.decimal "labHrs"
    t.decimal "tutorialHrs"
    t.text "equipment"
    t.text "room"
    t.string "responsible_person"
    t.text "comment"
    t.string "aasm_state"
  end

  create_table "faculties", force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "programs", force: :cascade do |t|
    t.text "name"
    t.text "code"
    t.text "mission"
    t.text "degree"
    t.integer "ects"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved", default: false, null: false
    t.string "role"
    t.string "full_name"
    t.bigint "faculty_id"
    t.boolean "readable"
    t.text "about"
    t.index ["approved"], name: "index_users_on_approved"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["faculty_id"], name: "index_users_on_faculty_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "course_programs", "courses"
  add_foreign_key "course_programs", "programs"
  add_foreign_key "users", "faculties"
end
