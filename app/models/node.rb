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

class Node < ActiveRecord::Base

  PUB_TYPE = 'pub'
  RESTAURANT_TYPE = 'restaurant'
  GALICIAN_CENTER_TYPE = 'galician_center'
  NODE_TYPES = [PUB_TYPE, RESTAURANT_TYPE, GALICIAN_CENTER_TYPE]

  default :node_type => PUB_TYPE

  validates_presence_of :title, :summary, :lat, :lng, :node_type
  validates_numericality_of :lat, :lng
  validates_acceptance_of :accept_terms, :accept => "1"

  has_many :comments, :dependent => :destroy

  def self.find_node_types
    return NODE_TYPES
  end

  def self.find_all
    find(:all)
  end
  
  def self.find_first
    find(:first, :order => "created_at")
  end

  def self.find_all_ordered
    find(:all, :order => "created_at DESC")
  end

  def self.find_highlighted
    find(:all, :limit => 4, :order => "rand()")
  end

  def self.find_front_page
    find(:first, :order => "rand()")
  end

  def self.find_last_nodes
    find(:all, :limit => 5, :order => "created_at desc")
  end

end
