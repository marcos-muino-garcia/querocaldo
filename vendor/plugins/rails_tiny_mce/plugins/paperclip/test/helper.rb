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

require 'rubygems'
require 'test/unit'
require 'shoulda'
require 'tempfile'

gem 'jferris-mocha', '0.9.5.0.1241126838'
require 'mocha'

gem 'sqlite3-ruby'

require 'active_record'
require 'active_support'
begin
  require 'ruby-debug'
rescue LoadError
  puts "ruby-debug not loaded"
end

ROOT       = File.join(File.dirname(__FILE__), '..')
RAILS_ROOT = ROOT
RAILS_ENV  = "test"

$LOAD_PATH << File.join(ROOT, 'lib')
$LOAD_PATH << File.join(ROOT, 'lib', 'paperclip')

require File.join(ROOT, 'lib', 'paperclip.rb')

require 'shoulda_macros/paperclip'

FIXTURES_DIR = File.join(File.dirname(__FILE__), "fixtures") 
config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + "/debug.log")
ActiveRecord::Base.establish_connection(config['test'])

def reset_class class_name
  ActiveRecord::Base.send(:include, Paperclip)
  Object.send(:remove_const, class_name) rescue nil
  klass = Object.const_set(class_name, Class.new(ActiveRecord::Base))
  klass.class_eval{ include Paperclip }
  klass
end

def reset_table table_name, &block
  block ||= lambda { |table| true }
  ActiveRecord::Base.connection.create_table :dummies, {:force => true}, &block
end

def modify_table table_name, &block
  ActiveRecord::Base.connection.change_table :dummies, &block
end

def rebuild_model options = {}
  ActiveRecord::Base.connection.create_table :dummies, :force => true do |table|
    table.column :other, :string
    table.column :avatar_file_name, :string
    table.column :avatar_content_type, :string
    table.column :avatar_file_size, :integer
    table.column :avatar_updated_at, :datetime
  end
  rebuild_class options
end

def rebuild_class options = {}
  ActiveRecord::Base.send(:include, Paperclip)
  Object.send(:remove_const, "Dummy") rescue nil
  Object.const_set("Dummy", Class.new(ActiveRecord::Base))
  Dummy.class_eval do
    include Paperclip
    has_attached_file :avatar, options
  end
end

def temporary_rails_env(new_env)
  old_env = Object.const_defined?("RAILS_ENV") ? RAILS_ENV : nil
  silence_warnings do
    Object.const_set("RAILS_ENV", new_env)
  end
  yield
  silence_warnings do
    Object.const_set("RAILS_ENV", old_env)
  end
end

class FakeModel
  attr_accessor :avatar_file_name,
                :avatar_file_size,
                :avatar_last_updated,
                :avatar_content_type,
                :id

  def errors
    @errors ||= []
  end

  def run_callbacks name, *args
  end
end

def attachment options
  Paperclip::Attachment.new(:avatar, FakeModel.new, options)
end

def silence_warnings
  old_verbose, $VERBOSE = $VERBOSE, nil
  yield
ensure
  $VERBOSE = old_verbose
end
