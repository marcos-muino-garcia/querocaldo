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

# Settings specified here will take precedence over those in config/environment.rb

# In the development environment your application's code is reloaded on
# every request.  This slows down response time but is perfect for development
# since you don't have to restart the webserver when you make code changes.
config.cache_classes = false

# Log error messages when you accidentally call methods on nil.
config.whiny_nils = true

# Show full error reports and disable caching
config.action_controller.consider_all_requests_local = true
config.action_view.debug_rjs                         = true
config.action_controller.perform_caching             = false

# Don't care if the mailer can't send
config.action_mailer.raise_delivery_errors = false

# http://localhost:3000
#GOOGLE_MAPS_KEY="ABQIAAAAGfWHPtUtuXBrIJs3BOS5UBTJQa0g3IQ9GZqIMmInSLzwtGDKaBRyzYRuTrQV_vLZt2SwOLAB-mTOXQ"

# http://querocaldo.org
GOOGLE_MAPS_KEY="ABQIAAAAGfWHPtUtuXBrIJs3BOS5UBSSJUnB4cBykaifb1-oj_OCdSenoRSagxPT-AE6wH6cQzDN69TGPK2Zvg"