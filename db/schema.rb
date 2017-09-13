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

ActiveRecord::Schema.define(version: 20170913130403) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "job_id"
    t.datetime "assignment_date"
    t.string "am_pm_visit"
    t.text "resolution"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "scheduled_date"
    t.date "actual_date"
    t.string "status"
    t.integer "contractor_id"
    t.string "signature"
    t.json "attachments"
    t.index ["job_id"], name: "index_assignments_on_job_id"
    t.index ["user_id"], name: "index_assignments_on_user_id"
  end

  create_table "attachments", force: :cascade do |t|
    t.string "attachment"
    t.bigint "assignment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id"], name: "index_attachments_on_assignment_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "items", force: :cascade do |t|
    t.string "sor_code"
    t.text "description"
    t.float "quantity"
    t.bigint "job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_items_on_job_id"
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
    t.date "reported_date"
    t.datetime "completed_date"
    t.text "reported_fault"
    t.text "notes"
    t.bigint "tenant_id"
    t.bigint "user_id"
    t.string "job_number"
    t.string "signature"
    t.integer "latest_assignment_id"
    t.bigint "priority_id"
    t.bigint "client_id"
    t.string "status"
    t.date "due_date"
    t.string "invoice_number"
    t.index ["client_id"], name: "index_jobs_on_client_id"
    t.index ["priority_id"], name: "index_jobs_on_priority_id"
    t.index ["tenant_id"], name: "index_jobs_on_tenant_id"
    t.index ["user_id"], name: "index_jobs_on_user_id"
  end

  create_table "priorities", force: :cascade do |t|
    t.string "priority"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level"
  end

  create_table "rpush_apps", force: :cascade do |t|
    t.string "name", null: false
    t.string "environment"
    t.text "certificate"
    t.string "password"
    t.integer "connections", default: 1, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type", null: false
    t.string "auth_key"
    t.string "client_id"
    t.string "client_secret"
    t.string "access_token"
    t.datetime "access_token_expiration"
  end

  create_table "rpush_feedback", force: :cascade do |t|
    t.string "device_token", limit: 64, null: false
    t.datetime "failed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "app_id"
    t.index ["device_token"], name: "index_rpush_feedback_on_device_token"
  end

  create_table "rpush_notifications", force: :cascade do |t|
    t.integer "badge"
    t.string "device_token", limit: 64
    t.string "sound", default: "default"
    t.text "alert"
    t.text "data"
    t.integer "expiry", default: 86400
    t.boolean "delivered", default: false, null: false
    t.datetime "delivered_at"
    t.boolean "failed", default: false, null: false
    t.datetime "failed_at"
    t.integer "error_code"
    t.text "error_description"
    t.datetime "deliver_after"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "alert_is_json", default: false
    t.string "type", null: false
    t.string "collapse_key"
    t.boolean "delay_while_idle", default: false, null: false
    t.text "registration_ids"
    t.integer "app_id", null: false
    t.integer "retries", default: 0
    t.string "uri"
    t.datetime "fail_after"
    t.boolean "processing", default: false, null: false
    t.integer "priority"
    t.text "url_args"
    t.string "category"
    t.boolean "content_available", default: false
    t.text "notification"
    t.index ["delivered", "failed"], name: "index_rpush_notifications_multi", where: "((NOT delivered) AND (NOT failed))"
  end

  create_table "tenants", force: :cascade do |t|
    t.string "name"
    t.text "address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contact_number_1"
    t.string "contact_number_2"
    t.string "contact_number_3"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "address"
    t.boolean "is_admin"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "username"
    t.string "email"
    t.string "phone_number"
    t.string "registration_id"
    t.boolean "active"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "assignments", "jobs"
  add_foreign_key "assignments", "users"
  add_foreign_key "assignments", "users", column: "contractor_id"
  add_foreign_key "attachments", "assignments"
  add_foreign_key "job_comments", "jobs"
  add_foreign_key "job_comments", "users"
  add_foreign_key "jobs", "clients"
  add_foreign_key "jobs", "priorities"
  add_foreign_key "jobs", "tenants"
  add_foreign_key "jobs", "users"
end
