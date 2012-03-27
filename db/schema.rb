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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120327215441) do

  create_table "entities", :force => true do |t|
    t.string   "name"
    t.text     "mesh"
    t.text     "collide"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.text     "animate"
    t.boolean  "pickup",     :default => false
  end

  create_table "levels", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "world_id"
    t.text     "blocks"
    t.text     "start"
    t.text     "entities"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "scores", :force => true do |t|
    t.integer  "score"
    t.integer  "level_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "scores", ["level_id"], :name => "index_scores_on_level_id"
  add_index "scores", ["user_id"], :name => "index_scores_on_user_id"

  create_table "themes", :force => true do |t|
    t.string   "name"
    t.string   "texture_sky"
    t.string   "texture_block"
    t.string   "texture_ball"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "users", :force => true do |t|
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.integer  "twitter_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "facebook_id"
    t.string   "avatar_url"
  end

  add_index "users", ["twitter_id"], :name => "index_users_on_twitter_id", :unique => true

  create_table "worlds", :force => true do |t|
    t.integer  "theme_id"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "worlds", ["theme_id"], :name => "index_worlds_on_theme_id"

end
