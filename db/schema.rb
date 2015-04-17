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

ActiveRecord::Schema.define(version: 20150416112452) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dashboard_widgets", force: true do |t|
    t.string   "access_token"
    t.string   "organization_name"
    t.string   "repo_name"
    t.string   "status"
    t.string   "github_url"
    t.string   "jira_url"
    t.string   "jira_view_id"
    t.string   "jira_name"
    t.string   "jira_password"
    t.string   "code_repo_id"
    t.string   "code_api_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "dashboard_id"
    t.integer  "widget_id"
    t.string   "jira_project_key"
  end

  add_index "dashboard_widgets", ["dashboard_id"], name: "index_dashboard_widgets_on_dashboard_id", using: :btree
  add_index "dashboard_widgets", ["widget_id"], name: "index_dashboard_widgets_on_widget_id", using: :btree

  create_table "dashboards", force: true do |t|
    t.string   "name"
    t.string   "icon"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "email"
    t.string   "status"
    t.string   "user_type"
    t.string   "password"
    t.string   "password_confirmation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "widgets", force: true do |t|
    t.string   "name"
    t.string   "widget_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
