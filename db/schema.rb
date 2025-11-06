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

ActiveRecord::Schema[8.1].define(version: 2025_11_06_220804) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "customers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer "balance_cents"
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.string "status"
    t.integer "total_cents"
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_invoices_on_customer_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "amount_cents"
    t.datetime "created_at", null: false
    t.bigint "invoice_id", null: false
    t.datetime "processed_at"
    t.datetime "updated_at", null: false
    t.index ["invoice_id"], name: "index_payments_on_invoice_id"
  end

  create_table "refunds", force: :cascade do |t|
    t.integer "amount_cents"
    t.datetime "created_at", null: false
    t.bigint "payment_id", null: false
    t.string "reason"
    t.datetime "updated_at", null: false
    t.index ["payment_id"], name: "index_refunds_on_payment_id"
  end

  add_foreign_key "invoices", "customers"
  add_foreign_key "payments", "invoices"
  add_foreign_key "refunds", "payments"
end
