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

ActiveRecord::Schema.define(:version => 20120923013216) do

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
    t.string   "number"
  end

  create_table "customers", :force => true do |t|
    t.text     "data"
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
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.binary   "image_s1_binary_data"
    t.binary   "image_s2_binary_data"
    t.string   "image_s1_content_type"
    t.string   "image_s1_filename"
    t.binary   "image_s4_binary_data"
    t.string   "image_s4_content_type"
    t.string   "image_s4_filename"
    t.string   "image_s2_content_type"
    t.string   "image_s2_filename"
  end

  create_table "events", :force => true do |t|
    t.integer  "category_id"
    t.integer  "invoice_id"
    t.string   "name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "customer_id"
    t.string   "place"
    t.text     "address"
    t.string   "ref"
    t.boolean  "is_free"
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

  create_table "invitems", :force => true do |t|
    t.integer  "invoiceable_id"
    t.string   "invoiceable_type"
    t.integer  "pos"
    t.string   "name"
    t.decimal  "qty"
    t.decimal  "price"
    t.integer  "kind"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "invoices", :force => true do |t|
    t.string   "number"
    t.text     "customer_data"
    t.date     "sent_at"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.date     "paid_at"
  end

  create_table "nositems", :force => true do |t|
    t.integer  "invoice_id"
    t.integer  "pos"
    t.string   "name"
    t.decimal  "qty"
    t.decimal  "price"
    t.integer  "kind"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "refacs", :force => true do |t|
    t.integer  "crentite_id"
    t.integer  "kind"
    t.decimal  "price"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "event_id"
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
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "rendezvous"
    t.datetime "surplace_at"
    t.datetime "depart_at"
    t.integer  "volness"
    t.integer  "stats_t1"
    t.integer  "stats_t2"
    t.integer  "stats_t3"
    t.integer  "stats_t4"
    t.integer  "stats_ambu"
    t.integer  "stats_pit"
    t.integer  "stats_smur"
    t.integer  "stats_dcd"
    t.integer  "subs"
    t.integer  "crentite_id"
  end

  create_table "servolos", :force => true do |t|
    t.datetime  "created_at", :null => false
    t.datetime  "updated_at", :null => false
    t.integer   "service_id"
    t.integer   "volo_id"
    t.timestamp "starts_at"
    t.timestamp "ends_at"
    t.string    "rendezvous"
  end

  create_table "templitems", :force => true do |t|
    t.integer  "pos"
    t.string   "name"
    t.integer  "kind"
    t.decimal  "price"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",                              :null => false
    t.string   "email",                              :null => false
    t.string   "crypted_password",                   :null => false
    t.string   "password_salt",                      :null => false
    t.string   "persistence_token",                  :null => false
    t.string   "single_access_token",                :null => false
    t.string   "perishable_token",                   :null => false
    t.integer  "login_count",         :default => 0, :null => false
    t.integer  "failed_login_count",  :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "volos", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "short_last_name"
    t.boolean  "actif"
    t.date     "birth_date"
    t.date     "local_date"
    t.integer  "crentite_id"
    t.text     "comment"
  end

end
