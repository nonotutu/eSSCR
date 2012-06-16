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

ActiveRecord::Schema.define(:version => 20120616131429) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "crentites", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "disposers", :force => true do |t|
    t.integer  "service_id"
    t.integer  "dispositif_id"
    t.integer  "quantity"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "crentite_id"
  end

  create_table "dispositifs", :force => true do |t|
    t.integer  "pos"
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "category_id"
    t.integer  "invoice_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "evitems", :force => true do |t|
    t.integer  "event_id"
    t.integer  "pos"
    t.string   "name"
    t.decimal  "qty"
    t.decimal  "price"
    t.integer  "kind"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "invoices", :force => true do |t|
    t.string   "number"
    t.text     "customer_data"
    t.date     "sent_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "seritems", :force => true do |t|
    t.integer  "service_id"
    t.integer  "pos"
    t.string   "name"
    t.decimal  "qty"
    t.decimal  "price"
    t.integer  "kind"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "services", :force => true do |t|
    t.integer  "event_id"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "servolos", :force => true do |t|
    t.datetime  "created_at", :null => false
    t.datetime  "updated_at", :null => false
    t.integer   "service_id"
    t.integer   "volo_id"
    t.timestamp "starts_at"
    t.timestamp "ends_at"
  end

  create_table "template_invoiced_items", :force => true do |t|
    t.integer  "pos"
    t.string   "name"
    t.integer  "kind"
    t.decimal  "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "volos", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
