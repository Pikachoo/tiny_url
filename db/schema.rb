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

ActiveRecord::Schema.define(version: 2021_08_29_200703) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "application_settings", force: :cascade do |t|
    t.string "name"
    t.integer "value"
  end

  create_table "urls", force: :cascade do |t|
    t.string "original"
    t.string "token"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["token"], name: "index_urls_on_token", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.bigint "ipv4"
    t.binary "ipv6"
    t.integer "count", default: 1
    t.bigint "url_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["url_id"], name: "index_visits_on_url_id"
  end

end
