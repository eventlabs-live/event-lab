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

ActiveRecord::Schema[7.1].define(version: 2024_11_07_203236) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "check_ins", force: :cascade do |t|
    t.bigint "ticket_id", null: false
    t.bigint "event_id", null: false
    t.string "checked_by_type", null: false
    t.bigint "checked_by_id", null: false
    t.datetime "timestamp"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checked_by_type", "checked_by_id"], name: "index_check_ins_on_checked_by"
    t.index ["event_id"], name: "index_check_ins_on_event_id"
    t.index ["ticket_id"], name: "index_check_ins_on_ticket_id"
  end

  create_table "event_registrations", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "event_id", null: false
    t.integer "quantity"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_registrations_on_event_id"
    t.index ["user_id"], name: "index_event_registrations_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "date"
    t.string "location"
    t.bigint "organizer_id", null: false
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "start_date"
    t.datetime "end_date"
    t.boolean "featured"
    t.string "category"
    t.integer "clicks"
    t.index ["organizer_id"], name: "index_events_on_organizer_id"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "registration_id", null: false
    t.decimal "amount"
    t.string "payment_method"
    t.integer "status"
    t.string "stripe_payment_intent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_payments_on_registration_id"
  end

  create_table "ticket_types", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.decimal "price"
    t.integer "capacity"
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_ticket_types_on_event_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "ticket_type_id", null: false
    t.bigint "registration_id", null: false
    t.string "qr_code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["registration_id"], name: "index_tickets_on_registration_id"
    t.index ["ticket_type_id"], name: "index_tickets_on_ticket_type_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "role"
    t.string "stripe_account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "check_ins", "events"
  add_foreign_key "check_ins", "tickets"
  add_foreign_key "event_registrations", "events"
  add_foreign_key "event_registrations", "users"
  add_foreign_key "events", "users", column: "organizer_id"
  add_foreign_key "payments", "event_registrations", column: "registration_id"
  add_foreign_key "ticket_types", "events"
  add_foreign_key "tickets", "event_registrations", column: "registration_id"
  add_foreign_key "tickets", "ticket_types"
end
