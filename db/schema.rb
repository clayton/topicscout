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

ActiveRecord::Schema[7.0].define(version: 2022_05_18_182708) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "interests", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "topic_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_interests_on_topic_id"
    t.index ["user_id"], name: "index_interests_on_user_id"
  end

  create_table "search_terms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "topic_id", null: false
    t.string "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_search_terms_on_topic_id"
  end

  create_table "topics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "topic"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tweet_read_receipts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tweet_id", null: false
    t.uuid "user_id", null: false
    t.uuid "interest_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interest_id"], name: "index_tweet_read_receipts_on_interest_id"
    t.index ["tweet_id"], name: "index_tweet_read_receipts_on_tweet_id"
    t.index ["user_id"], name: "index_tweet_read_receipts_on_user_id"
  end

  create_table "tweets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "twitter_search_result_id", null: false
    t.uuid "topic_id", null: false
    t.string "username"
    t.string "name"
    t.string "profile_image_url"
    t.text "text"
    t.string "tweet_id"
    t.string "author_id"
    t.string "intent"
    t.datetime "tweeted_at"
    t.text "embed_html"
    t.datetime "embed_cache_expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_tweets_on_topic_id"
    t.index ["tweet_id"], name: "index_tweets_on_tweet_id"
    t.index ["twitter_search_result_id"], name: "index_tweets_on_twitter_search_result_id"
  end

  create_table "twitter_search_results", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "topic_id", null: false
    t.string "newest_tweet_id"
    t.string "oldest_tweet_id"
    t.integer "tweets_count", default: 0
    t.integer "max_results", default: 10
    t.boolean "completed", default: false
    t.datetime "start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_twitter_search_results_on_topic_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "email"
    t.string "image"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "interests", "topics"
  add_foreign_key "interests", "users"
  add_foreign_key "search_terms", "topics"
  add_foreign_key "tweet_read_receipts", "interests"
  add_foreign_key "tweet_read_receipts", "tweets"
  add_foreign_key "tweet_read_receipts", "users"
  add_foreign_key "tweets", "topics"
  add_foreign_key "tweets", "twitter_search_results"
  add_foreign_key "twitter_search_results", "topics"
end
