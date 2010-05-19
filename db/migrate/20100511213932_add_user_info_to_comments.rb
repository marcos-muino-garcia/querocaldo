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

class AddUserInfoToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :user_name, :string
    add_column :comments, :user_email, :string
    add_column :comments, :lat, :float
    add_column :comments, :lng, :float
  end

  def self.down
    remove_column :comments, :user_name
    remove_column :comments, :user_email
    remove_column :comments, :lat
    remove_column :comments, :lng
  end
end
