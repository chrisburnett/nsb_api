# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170613084927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "job_id"
    t.date "assignment_date"
    t.string "am_pm_visit"
    t.text "resolution"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "scheduled_date"
    t.date "actual_date"
    t.index ["job_id"], name: "index_assignments_on_job_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "job_comments", force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "user_id"
    t.text "comment_text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_job_comments_on_job_id"
    t.index ["user_id"], name: "index_job_comments_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.datetime "reported_date"
    t.datetime "completed_date"
    t.text "reported_fault"
    t.text "sor_code"
    t.text "description"
    t.text "notes"
    t.bigint "tenant_id"
    t.bigint "user_id"
    t.string "short_title"
    t.boolean "assigned"
    t.boolean "completed"
    t.index ["tenant_id"], name: "index_jobs_on_tenant_id"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.boolean "is_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "username"
  end

  add_foreign_key "assignments", "jobs"
  add_foreign_key "assignments", "users"
  add_foreign_key "job_comments", "jobs"
  add_foreign_key "job_comments", "users"
  add_foreign_key "jobs", "tenants"
  add_foreign_key "jobs", "users"
end
