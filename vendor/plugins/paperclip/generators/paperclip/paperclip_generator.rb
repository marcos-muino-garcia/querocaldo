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

class PaperclipGenerator < Rails::Generator::NamedBase
  attr_accessor :attachments, :migration_name
 
  def initialize(args, options = {})
    super
    @class_name, @attachments = args[0], args[1..-1]
  end
 
  def manifest    
    file_name = generate_file_name
    @migration_name = file_name.camelize
    record do |m|
      m.migration_template "paperclip_migration.rb.erb",
                           File.join('db', 'migrate'),
                           :migration_file_name => file_name
    end
  end 
  
  private 
  
  def generate_file_name
    names = attachments.map{|a| a.underscore }
    names = names[0..-2] + ["and", names[-1]] if names.length > 1
    "add_attachments_#{names.join("_")}_to_#{@class_name.underscore}"
  end
 
end
