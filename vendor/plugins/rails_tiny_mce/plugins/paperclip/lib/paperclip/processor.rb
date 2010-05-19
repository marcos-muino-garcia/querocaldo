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
  # Paperclip processors allow you to modify attached files when they are
  # attached in any way you are able. Paperclip itself uses command-line
  # programs for its included Thumbnail processor, but custom processors
  # are not required to follow suit.
  #
  # Processors are required to be defined inside the Paperclip module and
  # are also required to be a subclass of Paperclip::Processor. There is
  # only one method you *must* implement to properly be a subclass: 
  # #make, but #initialize may also be of use. Both methods accept 3
  # arguments: the file that will be operated on (which is an instance of
  # File), a hash of options that were defined in has_attached_file's
  # style hash, and the Paperclip::Attachment itself.
  #
  # All #make needs to return is an instance of File (Tempfile is
  # acceptable) which contains the results of the processing.
  #
  # See Paperclip.run for more information about using command-line
  # utilities from within Processors.
  class Processor
    attr_accessor :file, :options, :attachment

    def initialize file, options = {}, attachment = nil
      @file = file
      @options = options
      @attachment = attachment
    end

    def make
    end

    def self.make file, options = {}, attachment = nil
      new(file, options, attachment).make
    end
  end
  
  # Due to how ImageMagick handles its image format conversion and how Tempfile
  # handles its naming scheme, it is necessary to override how Tempfile makes
  # its names so as to allow for file extensions. Idea taken from the comments
  # on this blog post:
  # http://marsorange.com/archives/of-mogrify-ruby-tempfile-dynamic-class-definitions
  class Tempfile < ::Tempfile
    # Replaces Tempfile's +make_tmpname+ with one that honors file extensions.
    def make_tmpname(basename, n)
      extension = File.extname(basename)
      sprintf("%s,%d,%d%s", File.basename(basename, extension), $$, n, extension)
    end
  end
end
