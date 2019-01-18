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

ActiveRecord::Schema.define(version: 2019_01_18_005818) do

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_authors_on_slug", unique: true
  end

  create_table "book_has_genres", force: :cascade do |t|
    t.integer "book_id"
    t.integer "genre_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_has_genres_on_book_id"
    t.index ["genre_id"], name: "index_book_has_genres_on_genre_id"
  end

  create_table "books", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.datetime "last_indexed"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.index ["slug"], name: "index_books_on_slug", unique: true
  end

  create_table "chapters", force: :cascade do |t|
    t.string "title"
    t.string "subtitle"
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_chapters_on_book_id"
  end

  create_table "character_appearances", force: :cascade do |t|
    t.integer "character_id"
    t.string "prose_type"
    t.integer "prose_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_id"], name: "index_character_appearances_on_character_id"
    t.index ["prose_type", "prose_id"], name: "index_character_appearances_on_prose_type_and_prose_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name"
    t.integer "notebook_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "corpus", force: :cascade do |t|
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "dactylograms", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "metrics"
    t.string "identifier"
    t.string "reference"
    t.integer "corpus_id"
    t.integer "user_id"
    t.index ["corpus_id"], name: "index_dactylograms_on_corpus_id"
    t.index ["user_id"], name: "index_dactylograms_on_user_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identities", force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "accesstoken"
    t.string "refreshtoken"
    t.string "uid"
    t.string "name"
    t.string "email"
    t.string "nickname"
    t.string "image"
    t.string "phone"
    t.string "urls"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.string "prose_type"
    t.integer "prose_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prose_type", "prose_id"], name: "index_metrics_on_prose_type_and_prose_id"
  end

  create_table "oauth_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publish_dates", force: :cascade do |t|
    t.date "published_at"
    t.integer "publisher_id"
    t.integer "author_id"
    t.integer "book_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_publish_dates_on_author_id"
    t.index ["book_id"], name: "index_publish_dates_on_book_id"
    t.index ["publisher_id"], name: "index_publish_dates_on_publisher_id"
  end

  create_table "publishers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
