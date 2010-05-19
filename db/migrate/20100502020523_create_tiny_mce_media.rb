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

class CreateTinyMceMedia < ActiveRecord::Migration
  def self.up
    create_table :prints do |t|
	#(Includes the file with image content)
         t.string    :image_file_name          #Uploading file/image
         t.string    :image_file_size
         t.string    :image_content_type
         t.timestamps
    end
  
    create_table :videos do |t|
	#(Includes the file with original content)
         t.string    :original_file_name          #Uploading file/image
         t.string    :original_file_size
         t.string    :original_content_type
         t.timestamps
    end
  end

  def self.down
    drop_table :prints
    drop_table :videos
  end
end