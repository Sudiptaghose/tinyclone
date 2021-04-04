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

ActiveRecord::Schema.define(version: 2021_04_06_000104) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "long_urls", force: :cascade do |t|
    t.string "url"
    t.string "token", limit: 5
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.binary "md5hash"
    t.index ["md5hash"], name: "index_long_urls_on_md5hash", unique: true
    t.index ["token"], name: "index_long_urls_on_token", unique: true
  end

  create_table "url_hits", force: :cascade do |t|
    t.bigint "long_url_id", null: false
    t.string "ip_address"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["long_url_id"], name: "index_url_hits_on_long_url_id"
  end

  add_foreign_key "url_hits", "long_urls"
end
