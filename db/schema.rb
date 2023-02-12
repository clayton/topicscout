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

ActiveRecord::Schema[7.0].define(version: 2023_02_10_232805) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "email_authentications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "code"
    t.datetime "expires_at"
    t.uuid "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_verifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.string "code"
    t.boolean "verified", default: false
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_email_verifications_on_user_id"
  end

  create_table "hashtag_entities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "hashtag_id"
    t.uuid "tweet_id"
    t.uuid "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_hashtag_entities_on_topic_id"
  end

  create_table "hashtags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "tweet_id"
  end

  create_table "negative_search_terms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "term"
    t.uuid "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_terms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "topic_id", null: false
    t.string "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_search_terms_on_topic_id"
  end

  create_table "subscriptions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status", default: "active"
    t.string "stripe_subscription_id", null: false
    t.string "stripe_customer_id", null: false
    t.string "stripe_customer_email", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_checkout_session_id", null: false
  end

  create_table "topics", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "topic"
    t.string "name"
    t.boolean "daily_digest", default: true
    t.boolean "weekly_digest", default: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "search_time_zone", default: "Pacific Time (US & Canada)"
    t.string "search_time_hour", default: "8"
    t.integer "utc_search_hour", default: 14
    t.string "filter_by_language"
    t.decimal "threshold", default: "0.0"
    t.index ["user_id"], name: "index_topics_on_user_id"
    t.index ["utc_search_hour"], name: "index_topics_on_utc_search_hour"
  end

  create_table "tweeter_ignore_rules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "topic_id", null: false
    t.string "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_tweeter_ignore_rules_on_topic_id"
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
    t.boolean "ignored", default: false
    t.integer "retweet_count", default: 0
    t.integer "reply_count", default: 0
    t.integer "like_count", default: 0
    t.integer "quote_count", default: 0
    t.integer "impression_count", default: 0
    t.string "lang"
    t.decimal "score", default: "0.0"
    t.boolean "saved", default: false
    t.boolean "archived", default: false
    t.index ["ignored"], name: "index_tweets_on_ignored"
    t.index ["topic_id"], name: "index_tweets_on_topic_id"
    t.index ["tweet_id"], name: "index_tweets_on_tweet_id"
    t.index ["twitter_search_result_id"], name: "index_tweets_on_twitter_search_result_id"
  end

  create_table "twitter_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "image"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "twitter_search_results", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "topic_id", null: false
    t.string "newest_tweet_id"
    t.string "oldest_tweet_id"
    t.integer "results_count", default: 0
    t.integer "max_results", default: 10
    t.boolean "limited", default: false
    t.boolean "completed", default: false
    t.datetime "start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "manual_search", default: false
    t.index ["topic_id"], name: "index_twitter_search_results_on_topic_id"
  end

  create_table "url_entities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tweet_id"
    t.uuid "url_id"
    t.uuid "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_url_entities_on_topic_id"
    t.index ["tweet_id"], name: "index_url_entities_on_tweet_id"
  end

  create_table "urls", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "display_url"
    t.string "title"
    t.string "status"
    t.string "unwound_url"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "tweet_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.string "email"
    t.string "image"
    t.string "username"
    t.uuid "subscription_id"
    t.boolean "email_verified", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "pay_customer_name"
  end

  add_foreign_key "email_verifications", "users"
  add_foreign_key "search_terms", "topics"
  add_foreign_key "topics", "users"
  add_foreign_key "tweeter_ignore_rules", "topics"
  add_foreign_key "tweets", "topics"
  add_foreign_key "tweets", "twitter_search_results"
  add_foreign_key "twitter_search_results", "topics"
end
