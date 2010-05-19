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

class NodesController < ApplicationController

  before_filter :authenticate, :only => [:index, :edit, :destroy]
  before_filter :load_sample_body, :only => [:new, :edit, :create]

  uses_tiny_mce(:options => AppConfig.custom_mce_options)

  def load_sample_body
      @sample_node = Node.find_first
  end

  # GET /nodes
  # GET /nodes.xml
  def index
    @nodes = Node.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nodes }
    end
  end

  # GET /nodes/1
  # GET /nodes/1.xml
  def show
    @node = Node.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @node }
    end
  end

  # GET /nodes/new
  # GET /nodes/new.xml
  def new
    @node = Node.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @node }
    end
  end

  # GET /nodes/1/edit
  def edit
    @node = Node.find(params[:id])
  end

  # POST /nodes
  # POST /nodes.xml
  def create
    @node = Node.new(params[:node])

    respond_to do |format|
      if @node.valid? && verify_recaptcha(@node) && @node.save
        
        xml = twitter(
          '/statuses/update.xml',
          { 'status' => "Contamos cun novo local: " + @node.title + " ( "+ url_for(@node) +" )"},
          :post
        )

        puts xml
        
        flash[:notice] = 'Node was successfully created.'
        format.html { redirect_to(@node) }
        format.xml  { render :xml => @node, :status => :created, :location => @node }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nodes/1
  # PUT /nodes/1.xml
  def update
    @node = Node.find(params[:id])

    respond_to do |format|
      if @node.update_attributes(params[:node])
        flash[:notice] = 'Node was successfully updated.'
        format.html { redirect_to(@node) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @node.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nodes/1
  # DELETE /nodes/1.xml
  def destroy
    @node = Node.find(params[:id])
    @node.destroy

    respond_to do |format|
      format.html { redirect_to(nodes_url) }
      format.xml  { head :ok }
    end
  end
  
  def twitter(command, opts={}, type=:get)
    # Open an HTTP connection to twitter.com
    twitter = Net::HTTP.start('twitter.com')

    # Depending on the request type, create either
    # an HTTP::Get or HTTP::Post object
    case type
    when :get
      # Append the options to the URL
      command << "?" + opts.map{|k,v| "#{k}=#{v}" }.join('&')
      req = Net::HTTP::Get.new(command)

    when :post
      # Set the form data with options
      req = Net::HTTP::Post.new(command)
      req.set_form_data(opts)
    end

    # Set up the authentication and
    # make the request
    req.basic_auth( TWITTER_USER, TWITTER_PASSWORD )
    res = twitter.request(req)
  end
 
end
