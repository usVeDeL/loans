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

ActiveRecord::Schema.define(version: 2021_07_24_062557) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_stat_statements"
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

  create_table "loan_movement_personal_groups", force: :cascade do |t|
    t.string "movement_type_id", null: false
    t.decimal "amount", precision: 14, scale: 2, null: false
    t.integer "personal_group_loan_id"
    t.integer "period"
    t.string "comments"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.integer "cycle"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "address_contract"
    t.string "adviser_name", default: ""
    t.datetime "disbursement_date", default: "2020-12-10 05:53:35"
    t.string "status"
    t.decimal "sum_payment_capital", default: "0.0"
    t.decimal "sum_payment_interest", default: "0.0"
    t.decimal "sum_week_payment", default: "0.0"
    t.string "type", default: "", null: false
    t.integer "payments_number", default: 16, null: false
    t.string "frecuency", default: "weekly", null: false
    t.index ["name", "cycle"], name: "index_loans_on_name_and_cycle", unique: true
  end

  create_table "logs", force: :cascade do |t|
    t.integer "user_id"
    t.string "description"
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

  create_table "payment_personal_groups", force: :cascade do |t|
    t.integer "period"
    t.integer "personal_group_loan_id"
    t.datetime "payment_date"
    t.decimal "capital_amount", precision: 14, scale: 2
    t.decimal "interest_amount", precision: 14, scale: 2
    t.decimal "period_amount", precision: 14, scale: 2
    t.decimal "balance_capital", precision: 14, scale: 2
    t.decimal "balance_interest", precision: 14, scale: 2
    t.decimal "wallet_amount", precision: 14, scale: 2
    t.decimal "percent_capital", precision: 14, scale: 2
    t.decimal "percent_interest", precision: 14, scale: 2
    t.string "status"
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

  create_table "personal_group_loans", force: :cascade do |t|
    t.integer "client_id", null: false
    t.decimal "amount", precision: 14, scale: 2, null: false
    t.decimal "interest_percent", precision: 14, scale: 2, null: false
    t.decimal "interest_monthly", precision: 14, scale: 2, null: false
    t.decimal "capital_amount", precision: 14, scale: 2, null: false
    t.decimal "payment_amount", precision: 14, scale: 2, null: false
    t.decimal "sum_interest", precision: 14, scale: 2
    t.decimal "sum_capital", precision: 14, scale: 2
    t.decimal "sum_payment_amount", precision: 14, scale: 2
    t.integer "payments_number", null: false
    t.string "frecuency", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.string "adviser_name"
    t.datetime "disbursement_date"
    t.string "address_contract"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "state_id", default: 1, null: false
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
    t.boolean "can_view_client_address", default: true
    t.boolean "can_delete_client_address", default: false
    t.boolean "can_edit_client_address", default: false
    t.boolean "can_create_client_address", default: false
    t.boolean "can_view_client_contact_types", default: true
    t.boolean "can_delete_client_contact_types", default: false
    t.boolean "can_edit_client_contact_types", default: false
    t.boolean "can_create_client_contact_types", default: false
    t.boolean "can_view_clients", default: true
    t.boolean "can_delete_clients", default: false
    t.boolean "can_edit_clients", default: false
    t.boolean "can_create_clients", default: false
    t.boolean "can_view_contact_types", default: true
    t.boolean "can_delete_contact_types", default: false
    t.boolean "can_edit_contact_types", default: false
    t.boolean "can_create_contact_types", default: false
    t.boolean "can_view_contracts", default: true
    t.boolean "can_delete_contracts", default: false
    t.boolean "can_edit_contracts", default: false
    t.boolean "can_create_contracts", default: false
    t.boolean "can_view_document_types", default: true
    t.boolean "can_delete_document_types", default: false
    t.boolean "can_edit_document_types", default: false
    t.boolean "can_create_document_types", default: false
    t.boolean "can_view_loan_clients", default: true
    t.boolean "can_delete_loan_clients", default: false
    t.boolean "can_edit_loan_clients", default: false
    t.boolean "can_create_loan_clients", default: false
    t.boolean "can_view_loan_movements", default: true
    t.boolean "can_delete_loan_movements", default: false
    t.boolean "can_edit_loan_movements", default: false
    t.boolean "can_create_loan_movements", default: false
    t.boolean "can_view_loans", default: true
    t.boolean "can_delete_loans", default: false
    t.boolean "can_edit_loans", default: false
    t.boolean "can_create_loans", default: false
    t.boolean "can_view_movement_types", default: true
    t.boolean "can_delete_movement_types", default: false
    t.boolean "can_edit_movement_types", default: false
    t.boolean "can_create_movement_types", default: false
    t.boolean "can_view_personal_documents", default: true
    t.boolean "can_delete_personal_documents", default: false
    t.boolean "can_edit_personal_documents", default: false
    t.boolean "can_create_personal_documents", default: false
    t.boolean "can_view_roles", default: true
    t.boolean "can_delete_roles", default: false
    t.boolean "can_edit_roles", default: false
    t.boolean "can_create_roles", default: false
    t.boolean "can_view_states", default: true
    t.boolean "can_delete_states", default: false
    t.boolean "can_edit_states", default: false
    t.boolean "can_create_states", default: false
    t.boolean "can_view_users", default: true
    t.boolean "can_delete_users", default: false
    t.boolean "can_edit_users", default: false
    t.boolean "can_create_users", default: false
    t.boolean "can_view_weekly_payments", default: true
    t.boolean "can_delete_weekly_payments", default: false
    t.boolean "can_edit_weekly_payments", default: false
    t.boolean "can_create_weekly_payments", default: false
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "transactions", force: :cascade do |t|
    t.float "amount"
    t.integer "loan_id"
    t.integer "loan_movement_id"
    t.integer "week"
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
    t.string "status"
  end

end
