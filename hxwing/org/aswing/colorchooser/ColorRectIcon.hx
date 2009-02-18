/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.colorchooser;  
import org.aswing.ASColor;
import org.aswing.Component;
import org.aswing.Icon;
import Import_org_aswing_graphics;
import flash.display.DisplayObject;

/**
 * @author iiley
 */
class ColorRectIcon implements Icon {
	
	var width:Int;
	var height:Int;
	var color:ASColor;
	
	public function new(width:Int, height:Int, color:ASColor){
		this.width = width;
		this.height = height;
		this.color = color;
	}
	
	public function setColor(color:ASColor):Void{
		this.color = color;
	}
	
	public function getColor():ASColor{
		return color;
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
	
	public function updateIcon(com:Component, g:Graphics2D, x:Int, y:Int):Void{
		var w:Int = width;
		var h:Int = height;
		g.fillRectangle(new SolidBrush(ASColor.WHITE), x, y, w, h);
		if(color != null){
			var t:Int = 5;
			var c:Int=0;
			while (c<w){
				g.drawLine(new Pen(ASColor.GRAY, 1), x+c, y, x+c, y+h);
				c+=t;
			}
			var r:Int=0;
			while (r<h){
				g.drawLine(new Pen(ASColor.GRAY, 1), x, y+r, x+w, y+r);
				r+=t;
			}
			g.fillRectangle(new SolidBrush(color), x, y, width, height);
		}else{
			g.drawLine(new Pen(ASColor.RED, 2), x+1, y+h-1, x+w-1, y+1);
		}
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return null;
	}	
}
