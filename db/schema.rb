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

ActiveRecord::Schema.define(version: 20160109100636) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true

  create_table "comment_valuations", force: :cascade do |t|
    t.boolean  "like",       default: false
    t.integer  "user_id"
    t.integer  "comment_id"
    t.integer  "lecture_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "comment_valuations", ["comment_id", "user_id"], name: "index_comment_valuations_on_comment_id_and_user_id"
  add_index "comment_valuations", ["comment_id"], name: "index_comment_valuations_on_comment_id"
  add_index "comment_valuations", ["lecture_id"], name: "index_comment_valuations_on_lecture_id"
  add_index "comment_valuations", ["user_id"], name: "index_comment_valuations_on_user_id"

  create_table "comments", force: :cascade do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "lecture_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "likedcount", default: 0
  end

  add_index "comments", ["lecture_id"], name: "index_comments_on_lecture_id"
  add_index "comments", ["user_id", "created_at"], name: "index_comments_on_user_id_and_created_at"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "enrollments", force: :cascade do |t|
    t.string   "day"
    t.string   "begin_time"
    t.string   "end_time"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "lecture_id"
    t.integer  "user_id"
    t.string   "days"
    t.integer  "timetable_id"
  end

  add_index "enrollments", ["timetable_id"], name: "index_enrollments_on_timetable_id"

  create_table "lectures", force: :cascade do |t|
    t.string   "subject"
    t.string   "professor"
    t.string   "major"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.string   "lecturetime"
    t.float    "acc_grade",       default: 0.0
    t.float    "acc_workload",    default: 0.0
    t.float    "acc_level",       default: 0.0
    t.float    "acc_achievement", default: 0.0
    t.float    "acc_homework",    default: 0.0
    t.float    "acc_total",       default: 0.0
    t.string   "place"
    t.string   "isu"
    t.string   "semester"
    t.float    "credit"
  end

  create_table "timetables", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "semester"
  end

  create_table "users", force: :cascade do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "image"
    t.string   "token"
    t.datetime "expires_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "nickname"
    t.boolean  "admin",           default: false
    t.string   "email"
    t.string   "password_digest"
    t.integer  "year"
    t.string   "major"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

  create_table "valuations", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lecture_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "up",          default: 0
    t.integer  "down",        default: 0
    t.integer  "grade"
    t.integer  "workload"
    t.integer  "level"
    t.integer  "achievement"
    t.integer  "homework"
    t.integer  "total"
    t.text     "content"
  end

end
