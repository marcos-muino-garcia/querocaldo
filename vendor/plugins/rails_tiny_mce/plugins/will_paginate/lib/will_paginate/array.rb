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

require 'will_paginate/collection'

# http://www.desimcadam.com/archives/8
Array.class_eval do
  def paginate(options = {})
    raise ArgumentError, "parameter hash expected (got #{options.inspect})" unless Hash === options
    
    WillPaginate::Collection.create(
        options[:page] || 1,
        options[:per_page] || 30,
        options[:total_entries] || self.length
    ) { |pager|
      pager.replace self[pager.offset, pager.per_page].to_a
    }
  end
end
