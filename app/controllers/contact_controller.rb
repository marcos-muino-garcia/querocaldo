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

class ContactController < ApplicationController
  def index
    @contact_email=CONTACT_EMAIL
  end

  def send_mail
    if params[:email][:address] =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
      Emailer::deliver_contact_email(params[:email])
    else
      flash[:notice] = I18n.t :error_mail_not_valid
      redirect_to :action=> 'index'
    end
  end

end
