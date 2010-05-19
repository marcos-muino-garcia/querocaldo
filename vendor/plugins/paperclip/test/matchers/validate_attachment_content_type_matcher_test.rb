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

class ValidateAttachmentContentTypeMatcherTest < Test::Unit::TestCase
  context "validate_attachment_content_type" do
    setup do
      reset_table("dummies") do |d|
        d.string :avatar_file_name
      end
      @dummy_class = reset_class "Dummy"
      @dummy_class.has_attached_file :avatar
      @matcher     = self.class.validate_attachment_content_type(:avatar).
                       allowing(%w(image/png image/jpeg)).
                       rejecting(%w(audio/mp3 application/octet-stream))
    end

    should "reject a class with no validation" do
      assert_rejects @matcher, @dummy_class
    end

    should "reject a class with a validation that doesn't match" do
      @dummy_class.validates_attachment_content_type :avatar, :content_type => %r{audio/.*}
      assert_rejects @matcher, @dummy_class
    end

    should "accept a class with a validation" do
      @dummy_class.validates_attachment_content_type :avatar, :content_type => %r{image/.*}
      assert_accepts @matcher, @dummy_class
    end
  end
end
