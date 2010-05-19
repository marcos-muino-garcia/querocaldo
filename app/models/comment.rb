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

class Comment < ActiveRecord::Base
  belongs_to :node

  validates_presence_of :body, :user_name
  validates_format_of :user_mail, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i

  def self.find_last_comments
    find(:all, :limit => 10, :order => "created_at desc")
  end

  require 'mathn'
  def distance_to_node
    radlat1 = Math::PI * lat / 180
    radlat2 = Math::PI * node.lat / 180
    radlng1 = Math::PI * lng / 180
    radlng2 = Math::PI * node.lng / 180
    theta = lng - node.lng
    radtheta = Math::PI * theta / 180
    dist = Math::sin(radlat1) * Math::sin(radlat2) + Math::cos(radlat1) * Math::cos(radlat2) * Math::cos(radtheta)
    dist = Math.acos(dist)
    dist = dist * 180 / Math::PI
    dist = dist * 60 * 1.1515
    dist = dist * 1.609344
    "%.2f" % dist
  end

end
