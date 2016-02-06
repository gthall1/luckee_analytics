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

ActiveRecord::Schema.define(version: 20160206011849) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "arrivals", force: true do |t|
    t.string   "landing_url"
    t.string   "ip"
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "user_email"
    t.datetime "user_created"
    t.datetime "arrival_created"
    t.integer  "mobile"
    t.string   "device"
    t.string   "referer"
    t.string   "user_agent"
    t.string   "platform"
    t.string   "browser"
    t.string   "version"
    t.boolean  "signup"
    t.integer  "games_played"
    t.integer  "credits_earned"
    t.integer  "cash_out_count"
    t.integer  "cash_out_value"
    t.integer  "surveys_taken"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "time_played"
  end

  create_table "cash_outs", force: true do |t|
    t.integer  "credits_earned"
    t.integer  "cash"
    t.string   "cash_out_type"
    t.datetime "cash_out_date"
    t.integer  "user_id"
    t.datetime "user_created"
    t.integer  "user_games_played"
    t.integer  "user_time_playing"
    t.float    "user_credits_per_game"
    t.float    "user_credits_per_minute"
    t.string   "referal"
    t.string   "device"
    t.integer  "arrival_id"
    t.datetime "arrival_created"
    t.string   "user_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "credits_spent"
  end

  create_table "daily_data", force: true do |t|
    t.datetime "date"
    t.integer  "arrivals"
    t.integer  "sign_ups"
    t.integer  "cash_outs"
    t.integer  "surveys"
    t.integer  "games_played"
    t.integer  "credits_earned"
    t.integer  "cash_payed_out"
    t.integer  "time_spent_playing"
    t.integer  "mobile_arrivals"
    t.integer  "desktop_arrivals"
    t.integer  "unique_users"
    t.float    "credits_per_minute"
    t.float    "cost_per_minute"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_users"
    t.integer  "user_churn"
  end

  create_table "game_sessions", force: true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.integer  "credits_earned"
    t.integer  "score"
    t.boolean  "active"
    t.integer  "arrival_id"
    t.string   "browser"
    t.string   "landing_page"
    t.string   "referer"
    t.string   "platform"
    t.string   "user_name"
    t.string   "game_name"
    t.string   "user_provider"
    t.integer  "time_played"
    t.float    "credits_per_minute"
    t.float    "cost_per_minute"
    t.datetime "user_created"
    t.datetime "game_session_created"
    t.datetime "game_session_updated"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "version"
  end

  create_table "games", force: true do |t|
    t.string   "name"
    t.string   "slug"
    t.integer  "sort_order"
    t.integer  "previous_sort_order"
    t.string   "sort_order_hash"
    t.datetime "sort_order_changed"
    t.datetime "game_added"
    t.integer  "total_credits_earned"
    t.integer  "device_type"
    t.integer  "total_games_played"
    t.integer  "total_time_spent_on_game"
    t.float    "credits_per_game"
    t.float    "time_per_game"
    t.float    "cost_per_game"
    t.float    "cost_per_minute"
    t.float    "avg_score"
    t.integer  "total_users_who_played"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monthly_data", force: true do |t|
    t.datetime "date"
    t.integer  "active_users"
    t.integer  "user_churn"
    t.integer  "arrivals"
    t.integer  "sign_ups"
    t.integer  "cash_outs"
    t.integer  "surveys"
    t.integer  "games_played"
    t.integer  "credits_earned"
    t.integer  "cash_payed_out"
    t.integer  "time_spent_playing"
    t.integer  "mobile_arrivals"
    t.integer  "desktop_arrivals"
    t.integer  "unique_users"
    t.float    "credits_per_minute"
    t.float    "cost_per_minute"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "surveys", force: true do |t|
    t.string   "name"
    t.integer  "credits"
    t.integer  "surveys_completed"
    t.integer  "all_credits_earned"
    t.integer  "avg_time_to_complete"
    t.datetime "survey_added"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "total_data", force: true do |t|
    t.datetime "date"
    t.integer  "arrivals"
    t.integer  "users"
    t.integer  "cash_outs"
    t.integer  "surveys"
    t.integer  "games_played"
    t.integer  "credits_earned"
    t.integer  "cash_payed_out"
    t.integer  "time_spent_playing"
    t.integer  "mobile_arrivals"
    t.integer  "desktop_arrivals"
    t.float    "credits_per_minute"
    t.float    "cost_per_minute"
    t.float    "games_per_arrival"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "avg_time_per_arrival"
  end

  create_table "user_surveys", force: true do |t|
    t.integer  "survey_id"
    t.integer  "user_id"
    t.integer  "arrival_id"
    t.integer  "arrival_created_at"
    t.string   "referer"
    t.string   "platform"
    t.string   "survey_name"
    t.datetime "user_created_at"
    t.datetime "survey_taken_at"
    t.datetime "survey_completed_at"
    t.boolean  "complete"
    t.integer  "credits_earned"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "user_created"
    t.datetime "user_updated"
    t.integer  "current_credits"
    t.integer  "credits_from_games"
    t.integer  "credits_from_surveys"
    t.integer  "lifetime_credits"
    t.boolean  "admin"
    t.string   "zipcode"
    t.string   "provider"
    t.integer  "cashed_out_credits"
    t.integer  "cash_outs"
    t.integer  "cash_out_value"
    t.integer  "surveys_complete"
    t.integer  "arrival_id"
    t.string   "origin_refer"
    t.string   "origin_device"
    t.string   "most_recent_device"
    t.integer  "game_sessions"
    t.integer  "unique_games_played"
    t.integer  "time_spent_playing"
    t.integer  "visits_to_site"
    t.float    "credits_per_game"
    t.float    "credits_per_minute"
    t.float    "cost_per_minute"
    t.float    "cost_per_game"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "most_recent_visit"
    t.integer  "visits_this_month"
  end

  create_table "weekly_data", force: true do |t|
    t.datetime "date"
    t.integer  "arrivals"
    t.integer  "sign_ups"
    t.integer  "cash_outs"
    t.integer  "surveys"
    t.integer  "games_played"
    t.integer  "credits_earned"
    t.integer  "cash_payed_out"
    t.integer  "time_spent_playing"
    t.integer  "mobile_arrivals"
    t.integer  "desktop_arrivals"
    t.integer  "unique_users"
    t.float    "credits_per_minute"
    t.float    "cost_per_minute"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "active_users"
    t.integer  "user_churn"
    t.integer  "total_users"
  end

end
