/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon;
	
import flash.display.DisplayObject;

import Import_org_aswing;
import org.aswing.geom.IntPoint;
import Import_org_aswing_graphics;
import org.aswing.plaf.UIResource;
import flash.geom.Point;
import flash.display.Shape;

/**
 * @private
 * @author iiley
 */
class SolidArrowIcon implements org.aswing.Icon, implements UIResource {
	
	
	
	var shape:Shape;
	var width:Int;
	var height:Int;
	var arrow:Float;
	var color:ASColor;
	
	public function new(arrow:Float, size:Int, color:ASColor){
		this.arrow = arrow;
		this.width = size;
		this.height = size;
		this.color = color;
		shape = new Shape();
		var x:Int = 0;
		var y:Int = 0;
		var g:Graphics2D = new Graphics2D(shape.graphics);
		var center:Point = new Point(x + width/2, y + height/2);
		var w:Int = width;
		var ps1:Array<Dynamic> = new Array();
		ps1.push(nextPoint(center, arrow, w/2/2));
		var back:Point = nextPoint(center, arrow + Math.PI, w/2/2);
		ps1.push(nextPoint(back, arrow - Math.PI/2, w/2));
		ps1.push(nextPoint(back, arrow + Math.PI/2, w/2));
		
		g.fillPolygon(new SolidBrush(color), ps1);
	}	
	
	public function updateIcon(com:Component, g:Graphics2D, x:Int, y:Int):Void{
		shape.x = x;
		shape.y = y;
	}
	
	//nextPoint with Point
	function nextPoint(op:Point, direction:Float, distance:Float):Point{
		return new Point(op.x+Math.cos(direction)*distance, op.y+Math.sin(direction)*distance);
	}
	
	public function getIconHeight(c:Component):Int{
		return height;
	}
	
	public function getIconWidth(c:Component):Int{
		return width;
	}
	
	public function setArrow(arrow:Float):Void{
		this.arrow = arrow;
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
	
}
