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

ActiveRecord::Schema.define(version: 20140430215959) do

  create_table "arbiters", force: true do |t|
    t.string   "username"
    t.string   "password_digest"
    t.string   "remember_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "arbiters", ["remember_token"], name: "index_arbiters_on_remember_token", unique: true
  add_index "arbiters", ["username"], name: "index_arbiters_on_username", unique: true

  create_table "nodes", force: true do |t|
    t.integer  "parent_story_id"
    t.integer  "parent_node_id"
    t.string   "contributor"
    t.text     "text"
    t.boolean  "is_active"
    t.boolean  "contributions_completed"
    t.boolean  "ratings_completed"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nodes", ["parent_node_id"], name: "index_nodes_on_parent_node_id"
  add_index "nodes", ["parent_story_id"], name: "index_nodes_on_parent_story_id"

  create_table "ratings", force: true do |t|
    t.integer  "node_id"
    t.integer  "rating1"
    t.integer  "rating2"
    t.integer  "rating3"
    t.integer  "rating4"
    t.string   "contributor"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["node_id"], name: "index_ratings_on_node_id"

  create_table "stories", force: true do |t|
    t.integer  "arbiter_id"
    t.integer  "root_node_id"
    t.string   "title"
    t.boolean  "complete"
    t.integer  "length"
    t.integer  "contributions_per_node"
    t.integer  "ratings_per_node"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stories", ["arbiter_id"], name: "index_stories_on_arbiter_id"
  add_index "stories", ["root_node_id"], name: "index_stories_on_root_node_id"

end
