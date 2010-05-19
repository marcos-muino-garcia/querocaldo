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

class AddSampleNode < ActiveRecord::Migration
  def self.up
    Node.create(
      :title => 'La Cervecería', 
      :lat => '43.3578', 
      :lng => '-8.40305', 
      :body => '<p><span style="font-size: medium;">O caldo que se sirve neste local non &eacute; nin de <a title="Grelos" href="http://gl.wikipedia.org/wiki/Grelo" target="_blank">grelos</a>, nin de <a title="Repolo" href="http://gl.wikipedia.org/wiki/Repolo" target="_blank">repolo</a>, &eacute; de cebada, e ven en forma de cervexa!</span></p>
<p style="text-align: center;"><span style="font-size: medium;"><span style="font-size: 10px;"><img src="/system/images/5/medium_thumb/la_cerveceria_estrella_IV.jpg" border="0" alt="image" width="98" height="100" style="border: 0px initial initial;" /></span></span></p>
<p><span style="font-size: medium;">Neste local, a principal protagonista, e a cerveza "</span><a title="Estrella Galicia" href="http://www.estrellagalicia.com/" target="_blank"><span style="font-size: medium;">Estrella Galicia</span></a><span style="font-size: medium;">", a&iacute;nda que tam&eacute;n contan cunha carta de tapas e bocadillos, digna de ser tida en conta cando a fame apreta.</span></p>
<p><span style="font-size: medium;">Adem&aacute;is de ser un dos puntos neur&aacute;lxicos de reuni&oacute;n calquera d&iacute;a da semana, tam&eacute;n conta cunha zona de restauraci&oacute;n, onde se poden degustar t&iacute;picos platos galegos.</span></p>
<p style="text-align: center;"><img src="/system/images/4/large_thumb/la_cerveceria_estrella_II.jpg" border="0" alt="image" width="370" height="246" /></p>
<p><span style="font-size: medium;">Non deixedes de visitarnos!!!</span></p>', 
      :summary => 'O local que albergaba a antiga fábrica de Estrella Galicia, foi reconvertido nun emblemático lugar onde se sirven máis de dous millóns de cañas ó ano',
      :node_type => 'pub')
  end

  def self.down
    Node.delete_all
  end
end
