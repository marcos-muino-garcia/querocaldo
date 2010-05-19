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

require 'active_record'
require 'active_record/version'
require 'active_record/fixtures'

class ActiveRecordTestConnector
  cattr_accessor :able_to_connect
  cattr_accessor :connected

  FIXTURES_PATH = File.join(File.dirname(__FILE__), '..', 'fixtures')

  # Set our defaults
  self.connected = false
  self.able_to_connect = true

  def self.setup
    unless self.connected || !self.able_to_connect
      setup_connection
      load_schema
      Dependencies.load_paths.unshift FIXTURES_PATH
      self.connected = true
    end
  rescue Exception => e  # errors from ActiveRecord setup
    $stderr.puts "\nSkipping ActiveRecord tests: #{e}"
    $stderr.puts "Install SQLite3 to run the full test suite for will_paginate.\n\n"
    self.able_to_connect = false
  end

  private

  def self.setup_connection
    db = ENV['DB'].blank?? 'sqlite3' : ENV['DB']
    
    configurations = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'database.yml'))
    raise "no configuration for '#{db}'" unless configurations.key? db
    configuration = configurations[db]
    
    ActiveRecord::Base.logger = Logger.new(STDOUT) if $0 == 'irb'
    puts "using #{configuration['adapter']} adapter" unless ENV['DB'].blank?
    
    ActiveRecord::Base.establish_connection(configuration)
    ActiveRecord::Base.configurations = { db => configuration }
    prepare ActiveRecord::Base.connection

    unless Object.const_defined?(:QUOTED_TYPE)
      Object.send :const_set, :QUOTED_TYPE, ActiveRecord::Base.connection.quote_column_name('type')
    end
  end

  def self.load_schema
    ActiveRecord::Base.silence do
      ActiveRecord::Migration.verbose = false
      load File.join(FIXTURES_PATH, 'schema.rb')
    end
  end

  def self.prepare(conn)
    class << conn
      IGNORED_SQL = [/^PRAGMA/, /^SELECT currval/, /^SELECT CAST/, /^SELECT @@IDENTITY/, /^SELECT @@ROWCOUNT/, /^SHOW FIELDS /]

      def execute_with_counting(sql, name = nil, &block)
        $query_count ||= 0
        $query_count  += 1 unless IGNORED_SQL.any? { |r| sql =~ r }
        execute_without_counting(sql, name, &block)
      end

      alias_method_chain :execute, :counting
    end
  end
end
