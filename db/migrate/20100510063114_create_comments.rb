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

class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.text :body,         :null => false
      t.integer :node_id,   :null => false

      t.timestamps
    end

    add_foreign_key(:comments, :nodes, :name => 'fk_comment_node')
  end

  def self.down
    remove_foreign_key(:comments, :name => 'fk_comment_node')

    drop_table :comments
  end
end
