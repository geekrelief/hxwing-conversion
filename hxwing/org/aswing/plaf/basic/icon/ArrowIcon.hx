/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon;

	
import Import_org_aswing_graphics;
import Import_org_aswing;
import Import_org_aswing_geom;
import flash.display.DisplayObject;
import org.aswing.plaf.UIResource;
import flash.geom.Point;

/**
 * @private
 */
class ArrowIcon implements org.aswing.Icon, implements UIResource {
	
	
	
	var arrow:Float;
	var width:Int;
	var height:Int;
	var shadow:ASColor;
	var darkShadow:ASColor;
	
	public function new(arrow:Float, size:Int, shadow:ASColor,
			 darkShadow:ASColor){
		this.arrow = arrow;
		this.width = size;
		this.height = size;
		this.shadow = shadow;
		this.darkShadow = darkShadow;
	}
	
	public function updateIcon(c:Component, g:Graphics2D, x:Int, y:Int):Void
	{
		var center:Point = new Point(c.getWidth()/2, c.getHeight()/2);
		var w:Int = width;
		var ps1:Array<Dynamic> = new Array();
		ps1.push(nextPoint(center, arrow, w/2/2));
		var back:Point = nextPoint(center, arrow + Math.PI, w/2/2);
		ps1.push(nextPoint(back, arrow - Math.PI/2, w/2));
		ps1.push(nextPoint(back, arrow + Math.PI/2, w/2));
		
		//w -= (w/4);
		var ps2:Array<Dynamic> = new Array();
		ps2.push(nextPoint(center, arrow, w/2/2-1));
		back = nextPoint(center, arrow + Math.PI, w/2/2-1);
		ps2.push(nextPoint(back, arrow - Math.PI/2, w/2-2));
		ps2.push(nextPoint(back, arrow + Math.PI/2, w/2-2));
		
		g.fillPolygon(new SolidBrush(darkShadow), ps1);
		g.fillPolygon(new SolidBrush(shadow), ps2);		
	}
	
	function nextPoint(p:Point, dir:Float, dis:Float):Point{
		return new Point(p.x+Math.cos(dir)*dis, p.y+Math.sin(dir)*dis);
	}
	
	public function getIconHeight(c:Component):Int
	{
		return width;
	}
	
	public function getIconWidth(c:Component):Int
	{
		return height;
	}
	
	public function getDisplay(c:Component):DisplayObject
	{
		return null;
	}
	
}
