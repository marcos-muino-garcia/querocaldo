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

class CommentsController < ApplicationController

  before_filter :authenticate, :only => [:destroy]

  def create
    @node = Node.find(params[:node_id])
    @comment = Comment.new(params[:comment])
    @comment.node = @node
    @comment.save!
    respond_to do |format|
      format.html { redirect_to @node }
      format.js
    end
  rescue
    respond_to do |format|
      format.html {
        render :action => 'show'
      }
      format.js {
        render :update do |page|
          page.replace_html :comment_errors, error_messages_for(:comment)
          page.visual_effect :highlight, :errors, :duration => 2
        end
      }
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @node = @comment.node
    @comment.destroy

    redirect_to edit_node_path @node
  end

end
