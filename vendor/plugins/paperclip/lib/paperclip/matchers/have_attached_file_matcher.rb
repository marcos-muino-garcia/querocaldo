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
      def have_attached_file name
        HaveAttachedFileMatcher.new(name)
      end

      class HaveAttachedFileMatcher
        def initialize attachment_name
          @attachment_name = attachment_name
        end

        def matches? subject
          @subject = subject
          responds? && has_column? && included?
        end

        def failure_message
          "Should have an attachment named #{@attachment_name}"
        end

        def negative_failure_message
          "Should not have an attachment named #{@attachment_name}"
        end

        def description
          "have an attachment named #{@attachment_name}"
        end

        protected

        def responds?
          methods = @subject.instance_methods.map(&:to_s)
          methods.include?("#{@attachment_name}") &&
            methods.include?("#{@attachment_name}=") &&
            methods.include?("#{@attachment_name}?")
        end

        def has_column?
          @subject.column_names.include?("#{@attachment_name}_file_name")
        end

        def included?
          @subject.ancestors.include?(Paperclip::InstanceMethods)
        end
      end
    end
  end
end
