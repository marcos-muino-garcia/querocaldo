# Copyright (C) 2010 Marcos Muíño García
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License Version 3
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100517174635) do

  create_table "comments", :force => true do |t|
    t.text     "body",       :null => false
    t.integer  "node_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_name"
    t.string   "user_email"
    t.float    "lat"
    t.float    "lng"
  end

  add_index "comments", ["node_id"], :name => "fk_comment_node"

  create_table "nodes", :force => true do |t|
    t.string   "title"
    t.float    "lat"
    t.float    "lng"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "summary"
    t.string   "node_type"
  end

  create_table "prints", :force => true do |t|
    t.string   "image_file_name"
    t.string   "image_file_size"
    t.string   "image_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_ip"
  end

  create_table "videos", :force => true do |t|
    t.string   "original_file_name"
    t.string   "original_file_size"
    t.string   "original_content_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "user_ip"
  end

  add_foreign_key "comments", "nodes", :name => "fk_comment_node"

end
