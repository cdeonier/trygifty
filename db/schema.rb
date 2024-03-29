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

ActiveRecord::Schema.define(:version => 20121114062533) do

  create_table "charges", :force => true do |t|
    t.integer  "pass_id"
    t.decimal  "amount"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "devices", :force => true do |t|
    t.string   "device_library_identifier"
    t.string   "push_token"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  create_table "items", :force => true do |t|
    t.integer  "vendor_id"
    t.decimal  "amount"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "items", ["vendor_id"], :name => "index_items_on_vendor_id"

  create_table "passes", :force => true do |t|
    t.integer  "vendor_id"
    t.string   "serial_number"
    t.decimal  "amount"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "item_id"
    t.string   "authentication_token"
  end

  add_index "passes", ["vendor_id"], :name => "index_passes_on_vendor_id"

  create_table "registrations", :force => true do |t|
    t.integer  "device_id"
    t.integer  "pass_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "transactions", :force => true do |t|
    t.integer  "item_id"
    t.string   "email"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "name"
    t.string   "sender_email"
    t.integer  "pass_id"
    t.string   "sender_name"
  end

  add_index "transactions", ["item_id"], :name => "index_transactions_on_item_id"

  create_table "vendors", :force => true do |t|
    t.string   "biz_id"
    t.string   "name"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.decimal  "latitude"
    t.decimal  "longitude"
    t.string   "foreground_color"
    t.string   "background_color"
    t.string   "facebook_page_id"
  end

end
