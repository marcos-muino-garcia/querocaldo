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

class AttachmentsController < ApplicationController
  skip_before_filter :verify_authenticity_token, :only => :create

  def manage
    @attachments = "#{params[:media]}".classify.constantize.paginate :page => params[:page], :order => 'created_at DESC', :per_page => 10
    render :update do |page|
      page.replace_html :dynamic_images_list, :partial => 'show_attachment_list'
    end
  end
  


  def create
    @attachment = "#{params[:media]}".classify.constantize.new(params[params[:media]])
    
    if @attachment.save
      GC.start
      responds_to_parent do
        render :update do |page|
          page << "upload_callback();"
        end
      end
    else
      responds_to_parent do
        render :update do |page|
          page.alert('Sorry, there was an error uploading the photo.')
        end
      end
    end
  end
end
