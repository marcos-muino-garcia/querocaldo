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

module Paperclip
  module Shoulda
    module Matchers
      def validate_attachment_presence name
        ValidateAttachmentPresenceMatcher.new(name)
      end

      class ValidateAttachmentPresenceMatcher
        def initialize attachment_name
          @attachment_name = attachment_name
        end

        def matches? subject
          @subject = subject
          error_when_not_valid? && no_error_when_valid?
        end

        def failure_message
          "Attachment #{@attachment_name} should be required"
        end

        def negative_failure_message
          "Attachment #{@attachment_name} should not be required"
        end

        def description
          "require presence of attachment #{@attachment_name}"
        end

        protected

        def error_when_not_valid?
          @attachment = @subject.new.send(@attachment_name)
          @attachment.assign(nil)
          not @attachment.errors[:presence].nil?
        end

        def no_error_when_valid?
          @file = StringIO.new(".")
          @attachment = @subject.new.send(@attachment_name)
          @attachment.assign(@file)
          @attachment.errors[:presence].nil?
        end
      end
    end
  end
end

