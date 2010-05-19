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

require 'test_helper'

class NodesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nodes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create node" do
    assert_difference('Node.count') do
      post :create, :node => { }
    end

    assert_redirected_to node_path(assigns(:node))
  end

  test "should show node" do
    get :show, :id => nodes(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => nodes(:one).to_param
    assert_response :success
  end

  test "should update node" do
    put :update, :id => nodes(:one).to_param, :node => { }
    assert_redirected_to node_path(assigns(:node))
  end

  test "should destroy node" do
    assert_difference('Node.count', -1) do
      delete :destroy, :id => nodes(:one).to_param
    end

    assert_redirected_to nodes_path
  end
end
