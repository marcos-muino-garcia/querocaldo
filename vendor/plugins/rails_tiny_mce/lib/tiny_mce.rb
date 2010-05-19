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

module TinyMCE
  module ClassMethods
    def uses_tiny_mce(options = {})
      tiny_mce_options = options.delete(:options) || nil
      proc = Proc.new do |c|
        c.instance_variable_set(:@tiny_mce_options, tiny_mce_options)
        c.instance_variable_set(:@uses_tiny_mce, true)
      end
      before_filter(proc, options)
    end
    alias uses_text_editor uses_tiny_mce
  end
  
  module OptionValidator
    class << self
      cattr_accessor :plugins
      
      def load
        @@valid_options = File.open(File.dirname(__FILE__) + "/../tiny_mce_options.yml") { |f| YAML.load(f.read) }
      end
      
      def valid?(option)
        @@valid_options.include?(option.to_s) || (plugins && plugins.include?(option.to_s.split('_')[0])) || option.to_s =~ /theme_advanced_container_/
      end
    
      def options
        @@valid_options
      end
    end
  end
  
  def self.included(base)
    base.extend(ClassMethods)
    base.helper TinyMCEHelper
  end
end
