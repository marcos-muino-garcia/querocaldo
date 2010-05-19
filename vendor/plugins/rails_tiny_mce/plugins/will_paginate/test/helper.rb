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

require 'test/unit'
require 'rubygems'

# gem install redgreen for colored test output
begin require 'redgreen'; rescue LoadError; end

require 'boot' unless defined?(ActiveRecord)

class Test::Unit::TestCase
  protected
  def assert_respond_to_all object, methods
    methods.each do |method|
      [method.to_s, method.to_sym].each { |m| assert_respond_to object, m }
    end
  end
  
  def collect_deprecations
    old_behavior = WillPaginate::Deprecation.behavior
    deprecations = []
    WillPaginate::Deprecation.behavior = Proc.new do |message, callstack|
      deprecations << message
    end
    result = yield
    [result, deprecations]
  ensure
    WillPaginate::Deprecation.behavior = old_behavior
  end
end

# Wrap tests that use Mocha and skip if unavailable.
def uses_mocha(test_name)
  require 'mocha' unless Object.const_defined?(:Mocha)
rescue LoadError => load_error
  $stderr.puts "Skipping #{test_name} tests. `gem install mocha` and try again."
else
  yield
end
