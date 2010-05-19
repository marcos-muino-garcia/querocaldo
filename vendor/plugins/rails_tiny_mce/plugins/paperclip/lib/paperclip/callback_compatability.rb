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
  # This module is intended as a compatability shim for the differences in
  # callbacks between Rails 2.0 and Rails 2.1.
  module CallbackCompatability
    def self.included(base)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    module ClassMethods
      # The implementation of this method is taken from the Rails 1.2.6 source,
      # from rails/activerecord/lib/active_record/callbacks.rb, line 192.
      def define_callbacks(*args)
        args.each do |method|
          self.class_eval <<-"end_eval"
            def self.#{method}(*callbacks, &block)
              callbacks << block if block_given?
              write_inheritable_array(#{method.to_sym.inspect}, callbacks)
            end
          end_eval
        end
      end
    end

    module InstanceMethods
      # The callbacks in < 2.1 don't worry about the extra options or the
      # block, so just run what we have available.
      def run_callbacks(meth, opts = nil, &blk)
        callback(meth)
      end
    end
  end
end
