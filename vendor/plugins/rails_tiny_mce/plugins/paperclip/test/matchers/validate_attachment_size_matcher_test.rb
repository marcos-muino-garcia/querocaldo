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

class ValidateAttachmentSizeMatcherTest < Test::Unit::TestCase
  context "validate_attachment_size" do
    setup do
      reset_table("dummies") do |d|
        d.string :avatar_file_name
      end
      @dummy_class = reset_class "Dummy"
      @dummy_class.has_attached_file :avatar
    end

    context "of limited size" do
      setup{ @matcher = self.class.validate_attachment_size(:avatar).in(256..1024) }

      should "reject a class with no validation" do
        assert_rejects @matcher, @dummy_class
      end

      should "reject a class with a validation that's too high" do
        @dummy_class.validates_attachment_size :avatar, :in => 256..2048
        assert_rejects @matcher, @dummy_class
      end

      should "reject a class with a validation that's too low" do
        @dummy_class.validates_attachment_size :avatar, :in => 0..1024
        assert_rejects @matcher, @dummy_class
      end

      should "accept a class with a validation that matches" do
        @dummy_class.validates_attachment_size :avatar, :in => 256..1024
        assert_accepts @matcher, @dummy_class
      end
    end

    context "validates_attachment_size with infinite range" do
      setup{ @matcher = self.class.validate_attachment_size(:avatar) }

      should "accept a class with an upper limit" do
        @dummy_class.validates_attachment_size :avatar, :less_than => 1
        assert_accepts @matcher, @dummy_class
      end

      should "accept a class with no upper limit" do
        @dummy_class.validates_attachment_size :avatar, :greater_than => 1
        assert_accepts @matcher, @dummy_class
      end
    end
  end
end
