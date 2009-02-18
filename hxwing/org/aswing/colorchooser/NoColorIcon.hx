/*
 Copyright aswing.org, see the LICENCE.txt.
*/
package org.aswing.colorchooser;  
import flash.display.DisplayObject;
import flash.display.Shape;

import org.aswing.ASColor;
import org.aswing.Component;
import org.aswing.Icon;
import Import_org_aswing_graphics;
/**
 * @author iiley
 */
class NoColorIcon implements Icon {
	
	
	
	var shape:Shape;
	var width:Int;
	var height:Int;
	
	public function new(width:Int, height:Int){
		this.width = width;
		this.height = height;
		shape = new Shape();
	}

	/**
	 * Return the icon's width.
	 */
	public function getIconWidth(c:Component):Int{
		return width;
	}
	
	/**
	 * Return the icon's height.
	 */
	public function getIconHeight(c:Component):Int{
		return height;
	}
	
	/**
	 * Draw the icon at the specified location.
	 */
	public function updateIcon(com:Component, g:Graphics2D, x:Int, y:Int):Void{
		shape.graphics.clear();
		g = new Graphics2D(shape.graphics);
		g.beginDraw(new Pen(ASColor.BLACK, 1));
		g.beginFill(new SolidBrush(ASColor.WHITE));
		var w:Int = Std.int(width/2 + 1);
		var h:Int = Std.int(height/2 + 1);
		x = Std.int(x + w/2 - 1);
		y = Std.int(y + h/2 - 1);
		g.rectangle(x, y, w, h);
		g.endFill();
		g.endDraw();
		g.drawLine(new Pen(ASColor.RED, 2), x+1, y+h-1, x+w-1, y+1);
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}	
}
