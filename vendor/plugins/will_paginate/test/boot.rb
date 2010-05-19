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

plugin_root = File.join(File.dirname(__FILE__), '..')
version = ENV['RAILS_VERSION']
version = nil if version and version == ""

# first look for a symlink to a copy of the framework
if !version and framework_root = ["#{plugin_root}/rails", "#{plugin_root}/../../rails"].find { |p| File.directory? p }
  puts "found framework root: #{framework_root}"
  # this allows for a plugin to be tested outside of an app and without Rails gems
  $:.unshift "#{framework_root}/activesupport/lib", "#{framework_root}/activerecord/lib", "#{framework_root}/actionpack/lib"
else
  # simply use installed gems if available
  puts "using Rails#{version ? ' ' + version : nil} gems"
  require 'rubygems'
  
  if version
    gem 'rails', version
  else
    gem 'actionpack'
    gem 'activerecord'
  end
end
