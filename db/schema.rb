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

ActiveRecord::Schema[7.0].define(version: 2023_03_09_135114) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "category_templates", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_category_templates_on_topic_id"
  end

  create_table "collection_categories", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "collection_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_collection_categories_on_collection_id"
  end

  create_table "collections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "user_id"
    t.uuid "topic_id", null: false
    t.index ["topic_id"], name: "index_collections_on_topic_id"
  end

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

  create_table "hashtags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "tag"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "tweet_id"
  end

  create_table "hostname_ignore_rules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "topic_id", null: false
    t.string "hostname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_hostname_ignore_rules_on_topic_id"
  end

  create_table "influenced_urls", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "influencer_id", null: false
    t.uuid "url_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["influencer_id"], name: "index_influenced_urls_on_influencer_id"
    t.index ["url_id", "influencer_id"], name: "index_influenced_urls_on_url_id_and_influencer_id", unique: true
    t.index ["url_id"], name: "index_influenced_urls_on_url_id"
  end

  create_table "influencers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "topic_id", null: false
    t.string "name"
    t.string "profile_image_url"
    t.string "profile_url"
    t.integer "influenced_count"
    t.integer "saved_count"
    t.integer "collected_count"
    t.string "platform_id"
    t.string "username"
    t.string "platform"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false
    t.string "verified_type"
    t.bigint "followers_count", default: 0
    t.bigint "following_count", default: 0
    t.bigint "tweet_count", default: 0
    t.bigint "listed_count", default: 0
    t.boolean "collected_tweets"
    t.boolean "saved_tweets"
    t.index ["topic_id"], name: "index_influencers_on_topic_id"
  end

  create_table "negative_search_terms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "term"
    t.uuid "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "remembered_sessions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id"
    t.datetime "expires_at", precision: nil, null: false
    t.string "lookup", null: false
    t.string "validator", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "search_terms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "topic_id", null: false
    t.string "term"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "required"
    t.boolean "exact_match"
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
    t.boolean "require_links"
    t.boolean "require_images"
    t.boolean "require_media"
    t.boolean "ignore_ads", default: false
    t.boolean "require_verified"
    t.boolean "deleted", default: false
    t.boolean "paused", default: false
    t.index ["user_id"], name: "index_topics_on_user_id"
    t.index ["utc_search_hour"], name: "index_topics_on_utc_search_hour"
  end

  create_table "tweeted_urls", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tweet_id"
    t.uuid "url_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tweet_id", "url_id"], name: "index_tweeted_urls_on_tweet_id_and_url_id", unique: true
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
    t.text "text"
    t.string "tweet_id"
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
    t.uuid "collection_id"
    t.string "twitter_list_id"
    t.uuid "influencer_id"
    t.datetime "published_at"
    t.string "author_id"
    t.string "author_name"
    t.string "author_username"
    t.string "author_profile_image_url"
    t.index ["collection_id"], name: "index_tweets_on_collection_id"
    t.index ["ignored"], name: "index_tweets_on_ignored"
    t.index ["influencer_id"], name: "index_tweets_on_influencer_id"
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
    t.string "auth_token"
    t.string "refresh_token"
    t.datetime "auth_token_expires_at"
  end

  create_table "twitter_lists", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "private"
    t.string "twitter_list_id"
    t.uuid "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "managed"
    t.index ["topic_id"], name: "index_twitter_lists_on_topic_id"
  end

  create_table "twitter_search_results", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "topic_id", null: false
    t.string "newest_tweet_id"
    t.string "oldest_tweet_id"
    t.integer "results_count", default: 0
    t.integer "max_results", default: 1000
    t.boolean "limited", default: false
    t.boolean "completed", default: false
    t.datetime "start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "manual_search", default: false
    t.integer "ignored_count", default: 0
    t.integer "added_count", default: 0
    t.boolean "errored", default: false
    t.string "error_message"
    t.text "error_description"
    t.text "query"
    t.boolean "list_search", default: false
    t.text "debug_description"
    t.index ["topic_id"], name: "index_twitter_search_results_on_topic_id"
  end

  create_table "urls", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "display_url"
    t.string "title"
    t.string "status"
    t.string "unwound_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "topic_id"
    t.string "editorial_title"
    t.string "editorial_url"
    t.text "editorial_description"
    t.string "editorial_category"
    t.boolean "ignored", default: false
    t.boolean "archived", default: false
    t.boolean "saved", default: false
    t.uuid "collection_id"
    t.float "score", default: 0.0
    t.datetime "published_at"
    t.string "clean_url"
    t.string "url_hash"
    t.integer "like_count", default: 0
    t.integer "retweet_count", default: 0
    t.integer "impression_count", default: 0
    t.index ["topic_id"], name: "index_urls_on_topic_id"
    t.index ["unwound_url"], name: "index_urls_on_unwound_url"
    t.index ["url_hash", "topic_id"], name: "index_urls_on_url_hash_and_topic_id"
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
    t.string "timezone", default: "UTC"
    t.boolean "beta", default: false
  end

  add_foreign_key "category_templates", "topics"
  add_foreign_key "collection_categories", "collections"
  add_foreign_key "collections", "topics"
  add_foreign_key "email_verifications", "users"
  add_foreign_key "hostname_ignore_rules", "topics"
  add_foreign_key "influenced_urls", "influencers"
  add_foreign_key "influenced_urls", "urls"
  add_foreign_key "influencers", "topics"
  add_foreign_key "search_terms", "topics"
  add_foreign_key "topics", "users"
  add_foreign_key "tweeter_ignore_rules", "topics"
  add_foreign_key "tweets", "topics"
  add_foreign_key "tweets", "twitter_search_results"
  add_foreign_key "twitter_lists", "topics"
  add_foreign_key "twitter_search_results", "topics"
end
