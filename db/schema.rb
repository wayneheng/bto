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

ActiveRecord::Schema.define(version: 20131106120304) do

  create_table "launches", force: true do |t|
    t.string   "title"
    t.integer  "version"
    t.string   "imagePath"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.string   "index"
    t.string   "title"
    t.integer  "flat_type"
    t.integer  "version"
    t.integer  "launch_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["launch_id"], name: "index_projects_on_launch_id"

  create_table "town_projects", force: true do |t|
    t.string   "town_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "launch_id"
  end

  create_table "units", force: true do |t|
    t.integer  "index"
    t.string   "title"
    t.string   "blk"
    t.string   "price"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "units", ["project_id"], name: "index_units_on_project_id"

end
