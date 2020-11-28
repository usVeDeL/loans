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

ActiveRecord::Schema.define(version: 2020_11_28_213731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "client_addresses", force: :cascade do |t|
    t.string "state_name"
    t.string "town"
    t.string "neighborhood"
    t.string "code_zip"
    t.string "street"
    t.string "number_exterior"
    t.string "number_interior"
    t.integer "client_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "client_contact_types", force: :cascade do |t|
    t.string "details"
    t.integer "client_id"
    t.integer "contact_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "last_name"
    t.string "mother_last_name"
    t.datetime "birth_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contact_types", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contract_loans", force: :cascade do |t|
    t.integer "loan_id"
    t.integer "contract_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "contracts", force: :cascade do |t|
    t.string "name"
    t.text "content_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "document_types", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.boolean "required"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "loan_clients", force: :cascade do |t|
    t.integer "client_id"
    t.float "amount"
    t.integer "group_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "loan_id"
  end

  create_table "loan_movements", force: :cascade do |t|
    t.integer "movement_type_id"
    t.float "amount"
    t.integer "loan_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "week"
    t.string "comments"
  end

  create_table "loans", force: :cascade do |t|
    t.string "name"
    t.float "loan_amount", default: 0.0
    t.float "interest_amount", default: 0.0
    t.float "weekly_amount", default: 0.0
    t.float "warranty", default: 0.0
    t.datetime "start_date"
    t.datetime "end_date"
    t.integer "state_id", default: 1
    t.integer "user_id"
    t.float "interest_percent", default: 0.0
    t.integer "adviser_id"
    t.integer "cycle"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "movement_types", force: :cascade do |t|
    t.string "name"
    t.string "kind_type"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "personal_documents", force: :cascade do |t|
    t.integer "client_id"
    t.integer "document_type_id"
    t.string "document"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.text "detail_loan"
    t.text "group_loan"
    t.text "state"
    t.text "movement_type"
    t.text "loan"
    t.text "movement"
    t.text "contact"
    t.text "document_type"
    t.text "contact_type"
    t.text "address"
    t.text "client"
    t.text "configuration"
    t.text "kind_type"
    t.text "notification"
    t.text "user"
    t.text "profile"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "mail", default: "", null: false
    t.boolean "active", default: true, null: false
    t.string "role_id", default: "seller", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "weekly_payments", force: :cascade do |t|
    t.integer "week"
    t.integer "loan_id"
    t.datetime "payment_date"
    t.float "payment_capital"
    t.float "payment_interest"
    t.float "week_payment"
    t.float "balance_capital"
    t.float "balance_interest"
    t.float "wallet_amout"
    t.float "percent_capital"
    t.float "percent_interest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
