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

class ValidateAttachmentPresenceMatcherTest < Test::Unit::TestCase
  context "validate_attachment_presence" do
    setup do
      reset_table("dummies"){|d| d.string :avatar_file_name }
      @dummy_class = reset_class "Dummy"
      @dummy_class.has_attached_file :avatar
      @matcher     = self.class.validate_attachment_presence(:avatar)
    end

    should "reject a class with no validation" do
      assert_rejects @matcher, @dummy_class
    end

    should "accept a class with a validation" do
      @dummy_class.validates_attachment_presence :avatar
      assert_accepts @matcher, @dummy_class
    end
  end
end
