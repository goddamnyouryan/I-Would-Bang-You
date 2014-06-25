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

ActiveRecord::Schema.define(:version => 20120119055906) do

  create_table "hides", :force => true do |t|
    t.integer  "user_id"
    t.integer  "hidden_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hides", ["hidden_id"], :name => "index_hides_on_hidden_id"
  add_index "hides", ["id"], :name => "index_hides_on_id"
  add_index "hides", ["user_id"], :name => "index_hides_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",       :default => "unread", :null => false
  end

  add_index "messages", ["id"], :name => "index_messages_on_id"
  add_index "messages", ["receiver_id"], :name => "index_messages_on_receiver_id"
  add_index "messages", ["sender_id"], :name => "index_messages_on_sender_id"
  add_index "messages", ["state"], :name => "index_messages_on_state"

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.string   "caption"
    t.boolean  "profile"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "photos", ["id"], :name => "index_photos_on_id"
  add_index "photos", ["user_id"], :name => "index_photos_on_user_id"

  create_table "questions", :force => true do |t|
    t.integer  "user_id"
    t.string   "question"
    t.text     "answer"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
  end

  add_index "questions", ["id"], :name => "index_questions_on_id"
  add_index "questions", ["kind"], :name => "index_questions_on_kind"
  add_index "questions", ["user_id"], :name => "index_questions_on_user_id"

  create_table "ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "mate_id"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ratings", ["id"], :name => "index_ratings_on_id"
  add_index "ratings", ["mate_id"], :name => "index_ratings_on_mate_id"
  add_index "ratings", ["status"], :name => "index_ratings_on_status"
  add_index "ratings", ["user_id"], :name => "index_ratings_on_user_id"

  create_table "responses", :force => true do |t|
    t.integer  "message_id"
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",       :default => "unread", :null => false
    t.string   "origin",      :default => "user",   :null => false
  end

  add_index "responses", ["id"], :name => "index_responses_on_id"
  add_index "responses", ["message_id"], :name => "index_responses_on_message_id"
  add_index "responses", ["origin"], :name => "index_responses_on_origin"
  add_index "responses", ["receiver_id"], :name => "index_responses_on_receiver_id"
  add_index "responses", ["sender_id"], :name => "index_responses_on_sender_id"
  add_index "responses", ["state"], :name => "index_responses_on_state"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",   :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",   :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login"
    t.string   "sex"
    t.boolean  "looking_for_men"
    t.boolean  "looking_for_women"
    t.date     "birthday"
    t.string   "zip"
    t.string   "city"
    t.string   "state"
    t.float    "latitude"
    t.float    "longitude"
    t.integer  "rating_count",                          :default => 1,    :null => false
    t.integer  "score",                                 :default => 0,    :null => false
    t.boolean  "email_match",                           :default => true, :null => false
    t.boolean  "email_message",                         :default => true, :null => false
    t.boolean  "email_rating",                          :default => true, :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["latitude"], :name => "index_users_on_latitude"
  add_index "users", ["longitude"], :name => "index_users_on_longitude"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["zip"], :name => "index_users_on_zip"

  create_table "visits", :force => true do |t|
    t.integer  "user_id"
    t.integer  "visitor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
