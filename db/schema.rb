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

ActiveRecord::Schema.define(version: 20170318045954) do

  create_table "options", force: :cascade do |t|
    t.string   "name"
    t.integer  "recorder_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["name", "recorder_id"], name: "index_options_on_name_and_recorder_id", unique: true
    t.index ["recorder_id", "created_at"], name: "index_options_on_recorder_id_and_created_at"
    t.index ["recorder_id"], name: "index_options_on_recorder_id"
  end

  create_table "recordabilities", force: :cascade do |t|
    t.integer  "recorder_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["recorder_id", "created_at"], name: "index_recordabilities_on_recorder_id_and_created_at"
    t.index ["recorder_id"], name: "index_recordabilities_on_recorder_id"
  end

  create_table "recorders", force: :cascade do |t|
    t.string   "title"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["updated_at"], name: "index_recorders_on_updated_at"
    t.index ["user_id", "created_at"], name: "index_recorders_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_recorders_on_user_id"
  end

  create_table "records", force: :cascade do |t|
    t.integer  "recordability_id"
    t.integer  "option_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "count"
    t.index ["option_id"], name: "index_records_on_option_id"
    t.index ["recordability_id", "created_at"], name: "index_records_on_recordability_id_and_created_at"
    t.index ["recordability_id"], name: "index_records_on_recordability_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin",           default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
