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

ActiveRecord::Schema.define(version: 2018_10_04_140257) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "timescaledb"

  create_table "events", primary_key: ["event_id", "event_source", "event_time"], force: :cascade do |t|
    t.bigint "event_id", null: false
    t.string "event_type"
    t.string "event_source", null: false
    t.datetime "event_time", null: false
    t.datetime "event_created_at"
    t.bigint "project_id"
    t.bigint "workflow_id"
    t.bigint "user_id"
    t.string "subject_ids", default: [], array: true
    t.string "subject_urls", default: [], array: true
    t.string "lang"
    t.string "user_agent"
    t.string "user_name"
    t.string "project_name"
    t.bigint "board_id"
    t.bigint "discussion_id"
    t.bigint "focus_id"
    t.string "focus_type"
    t.string "section"
    t.text "body"
    t.string "url"
    t.string "focus"
    t.string "board"
    t.string "tags", default: [], array: true
    t.bigint "user_zooniverse_id"
    t.bigint "zooniverse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_time"], name: "events_event_time_idx", order: :desc
  end

end
