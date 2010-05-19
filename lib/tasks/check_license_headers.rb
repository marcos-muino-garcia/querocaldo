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

class HeadersCheck

  def check_files(dir)
    count = FileList["**/*.{rb,yml,erb,rjs}"].inject(0) do |count, filename|
        match = nil
        File.open(filename) do |f|
          # Checking for the Copyright header in the 4 first lines
          4.times { match ||= (/Copyright/ =~ f.readline) rescue nil }
        end

        unless match
          when_writing("Missing header in #{filename}") {
            add_header(filename);
            count+= 1
          }
        end

        count
    end

    puts "#{count} files don't have been checked."
  end

  def add_header(filename)
    ext = /\.([^\.]*)$/.match(filename[1..-1])[1]
    header, content = HEADERS[ext], ''
    File.open(filename, 'r') { |file| content = file.read }
    if content[0..4] == '<?xml'
      content = content[0..content.index("\n")] + header + content[(content.index("\n") + 1)..-1]
    else
      content = header + content
    end
    File.open(filename, 'w') { |file| file.write(content) }
  end

end

RB_HEADER = <<RB
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

RB

ERB_HEADER =<<ERB
<%
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
-%>
ERB

HEADERS = {
  'rb' => RB_HEADER,
  'yml' => RB_HEADER,
  'erb' => ERB_HEADER,
  'rjs' => RB_HEADER
}

# if ['-h', '--help', 'help'].include? ARGV[0]
#  puts "Scans the current directory for files with missing Apache "
#  puts "license headers."
#  puts "   ruby check_license_headers.rb      # list files"
#  puts "   ruby check_license_headers.rb add  # add headers automatically"
# else
#  HeadersCheck.new.check_files('.', ARGV[0] != 'add')
# end
