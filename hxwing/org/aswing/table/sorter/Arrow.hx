/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.table.sorter;

import org.aswing.ASColor;
import org.aswing.Component;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import org.aswing.Icon;
import flash.geom.Point;
import flash.display.DisplayObject;
import flash.display.Shape;

/**
 * @author iiley
 */
class Arrow implements Icon {
	
	
	
	var shape:Shape;
	var width:Int;
	var arrow:Float;
	
	public function new(descending:Bool, size:Int){
		shape = new Shape();
		arrow = descending ? Math.PI/2 : -Math.PI/2;
		this.width = size;
	}
	
	public function getIconWidth(c:Component) : Int {
		return width;
	}

	public function getIconHeight(c:Component) : Int {
		return width;
	}

	public function updateIcon(com:Component, g:Graphics2D, x:Int, y:Int):Void{
		shape.graphics.clear();
		g = new Graphics2D(shape.graphics);
		var center:Point = new Point(x, com.getHeight()/2);
		var w:Int = width;
		
		var ps1:Array<Dynamic> = new Array();
		ps1.push(nextPoint(center, arrow, w/2/2));
		var back:Point = nextPoint(center, arrow + Math.PI, w/2/2);
		ps1.push(nextPoint(back, arrow - Math.PI/2, w/2));
		ps1.push(nextPoint(back, arrow + Math.PI/2, w/2));
		
		g.fillPolygon(new SolidBrush(ASColor.BLACK), ps1);	
	}
	
	function nextPoint(p:Point, dir:Float, dis:Float):Point{
		return new Point(p.x+Math.cos(dir)*dis, p.y+Math.sin(dir)*dis);
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
}
