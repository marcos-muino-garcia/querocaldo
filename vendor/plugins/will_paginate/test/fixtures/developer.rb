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

class Developer < User
  has_and_belongs_to_many :projects, :include => :topics, :order => 'projects.name'

  def self.with_poor_ones(&block)
    with_scope :find => { :conditions => ['salary <= ?', 80000], :order => 'salary' } do
      yield
    end
  end

  named_scope :poor, :conditions => ['salary <= ?', 80000], :order => 'salary'

  def self.per_page() 10 end
end
