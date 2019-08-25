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

ActiveRecord::Schema.define(version: 20190703051851) do

  create_table "deck_entries", force: :cascade do |t|
    t.integer "deck_id"
    t.integer "my_card_id"
    t.integer "quantity"
  end

  create_table "decks", force: :cascade do |t|
    t.string "name"
    t.string "format"
  end

  create_table "magic_cards", force: :cascade do |t|
    t.string  "name"
    t.integer "cmc"
    t.string  "rarity"
    t.string  "price"
    t.string  "image_url"
    t.string  "multiverse_id"
    t.string  "mana_cost"
    t.string  "card_type"
  end

  create_table "my_cards", force: :cascade do |t|
    t.string  "name"
    t.integer "quantity"
    t.integer "box"
    t.integer "magic_card_id"
  end
end
