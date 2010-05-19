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

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  before_filter :set_locale
  before_filter :get_last_nodes

  protected

  def get_last_nodes
    @last_nodes = Node.find_last_nodes
  end

  def set_locale
    # if params[:locale] is nil then I18n.default_locale will be used
    I18n.locale = (AVAILABLE_LOCALES.keys.include? params[:locale]) ? params[:locale] : nil
    @available_locales = AVAILABLE_LOCALES;
  end

  def default_url_options(options={})
    # logger.debug "default_url_options is passed options: #{options.inspect}\n"
    { :locale => I18n.locale }
  end

  def authenticate
    authenticate_or_request_with_http_basic do |name, password|
      name == ADMIN_USER && password == ADMIN_PASSWORD
    end
  end

end
