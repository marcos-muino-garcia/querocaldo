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

class Project < ActiveRecord::Base
  has_and_belongs_to_many :developers, :uniq => true
  
  has_many :topics
    # :finder_sql  => 'SELECT * FROM topics WHERE (topics.project_id = #{id})',
    # :counter_sql => 'SELECT COUNT(*) FROM topics WHERE (topics.project_id = #{id})'
  
  has_many :replies, :through => :topics do
    def find_recent(params = {})
      with_scope :find => { :conditions => ['replies.created_at > ?', 15.minutes.ago] } do
        find :all, params
      end
    end
  end
end
