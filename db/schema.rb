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

ActiveRecord::Schema.define(:version => 20110706165340) do

  create_table "dimensions", :force => true do |t|
    t.string   "name"
    t.integer  "height"
    t.integer  "width"
    t.float    "aspect"
    t.boolean  "crop"
    t.boolean  "resize"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "galleries", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "holder_id"
    t.string   "holder_type"
    t.integer  "gallery_image_id"
    t.integer  "gallery_dimension_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gdjoins", :force => true do |t|
    t.integer "gallery_id"
    t.integer "dimension_id"
  end

  create_table "images", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "original_filename"
    t.integer  "height"
    t.integer  "width"
    t.integer  "gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.string   "source_link"
    t.string   "live_link"
    t.string   "client"
    t.date     "completed"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
