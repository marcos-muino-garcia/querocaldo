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

require 'lib/activerecord_test_connector'

class ActiveRecordTestCase < Test::Unit::TestCase
  # Set our fixture path
  if ActiveRecordTestConnector.able_to_connect
    self.fixture_path = File.join(File.dirname(__FILE__), '..', 'fixtures')
    self.use_transactional_fixtures = true
  end

  def self.fixtures(*args)
    super if ActiveRecordTestConnector.connected
  end

  def run(*args)
    super if ActiveRecordTestConnector.connected
  end

  # Default so Test::Unit::TestCase doesn't complain
  def test_truth
  end

  protected

    def assert_queries(num = 1)
      $query_count = 0
      yield
    ensure
      assert_equal num, $query_count, "#{$query_count} instead of #{num} queries were executed."
    end

    def assert_no_queries(&block)
      assert_queries(0, &block)
    end
end

ActiveRecordTestConnector.setup
