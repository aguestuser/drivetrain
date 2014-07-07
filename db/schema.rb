# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140707095837) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contact_infos", force: true do |t|
    t.string   "phone"
    t.string   "email"
    t.string   "street_address"
    t.string   "borough"
    t.string   "neighborhood"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contactable_id"
    t.string   "contactable_type"
    t.string   "name"
    t.string   "title"
  end

  add_index "contact_infos", ["contactable_id"], name: "index_contact_infos_on_contactable_id", using: :btree
  add_index "contact_infos", ["email"], name: "index_contact_infos_on_email", unique: true, using: :btree

  create_table "managers", force: true do |t|
    t.integer  "restaurant_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "managers", ["restaurant_id"], name: "index_managers_on_restaurant_id", using: :btree

  create_table "restaurants", force: true do |t|
    t.boolean  "active"
    t.string   "status"
    t.text     "description"
    t.string   "agency_payment_method"
    t.boolean  "pickup_required"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shifts", force: true do |t|
    t.integer  "restaurant_id"
    t.datetime "start"
    t.datetime "end"
    t.string   "period"
    t.string   "urgency"
    t.string   "billing_rate"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shifts", ["restaurant_id"], name: "index_shifts_on_restaurant_id", using: :btree

  create_table "staffers", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "work_arrangements", force: true do |t|
    t.string   "zone"
    t.string   "daytime_volume"
    t.string   "evening_volume"
    t.string   "pay_rate"
    t.boolean  "shift_meal"
    t.boolean  "cash_out_tips"
    t.boolean  "rider_on_premises"
    t.boolean  "extra_work"
    t.string   "extra_work_description"
    t.boolean  "bike"
    t.boolean  "lock"
    t.boolean  "rack"
    t.boolean  "bag"
    t.boolean  "heated_bag"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "restaurant_id"
    t.string   "rider_payment_method"
  end

  add_index "work_arrangements", ["restaurant_id"], name: "index_work_arrangements_on_restaurant_id", using: :btree

end
