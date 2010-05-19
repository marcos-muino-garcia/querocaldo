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

require 'test/helper'

class HaveAttachedFileMatcherTest < Test::Unit::TestCase
  context "have_attached_file" do
    setup do
      @dummy_class = reset_class "Dummy"
      reset_table "dummies"
      @matcher     = self.class.have_attached_file(:avatar)
    end

    should "reject a class with no attachment" do
      assert_rejects @matcher, @dummy_class
    end

    should "accept a class with an attachment" do
      modify_table("dummies"){|d| d.string :avatar_file_name }
      @dummy_class.has_attached_file :avatar
      assert_accepts @matcher, @dummy_class
    end
  end
end
