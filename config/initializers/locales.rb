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

LOCALES_DIRECTORY = "#{RAILS_ROOT}/config/locales/" 
AVAILABLE_LOCALES =
Dir.new(LOCALES_DIRECTORY).entries.collect do |x|
  x =~ /\.yml/ ? x.sub(/\.yml/,"") : nil
end.compact.each_with_object({}) do |str, hsh|
  hsh[str] = YAML.load_file(LOCALES_DIRECTORY + str + ".yml")[str]["this_file_language"]
end.freeze # {"it-IT" => "Italiano", "en-US" => "American English"}
