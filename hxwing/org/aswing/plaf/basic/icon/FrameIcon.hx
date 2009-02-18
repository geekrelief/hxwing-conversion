/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon;

import flash.display.DisplayObject;
import flash.display.Shape;

import Import_org_aswing;
import org.aswing.graphics.Graphics2D;
import org.aswing.plaf.UIResource;

/**
 * Frame title bar icon base.
 * @author iiley
 * @private
 */
class FrameIcon implements org.aswing.Icon, implements UIResource {
		
	
		
	static var DEFAULT_ICON_WIDTH:Int = 13;
	
	var width:Int;
	var height:Int;
	var shape:Shape;
	
	var color:ASColor;
	var disabledColor:ASColor;
		
	/**
	 * @param width the width of the icon square.
	 */	
	public function new(?width:Int){
        if(width == null){
            width = DEFAULT_ICON_WIDTH;
        }
		this.width = width;
		height = width;
		shape = new Shape();
	}
	
	public function getColor(c:Component):ASColor{
		if(c.isEnabled()){
			return color;
		}else{
			return disabledColor;
		}
	}
	
	public function updateIcon(c:Component, g:Graphics2D, x:Int, y:Int):Void
	{
		if(color == null){
			color = c.getUI().getColor("Frame.activeCaptionText");
			disabledColor = new ASColor(color.getRGB(), 0.5);
		}
		shape.graphics.clear();
		updateIconImp(c, new Graphics2D(shape.graphics), x, y);
	}
	
	public function updateIconImp(c:Component, g:Graphics2D, x:Int, y:Int):Void{}
	
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
		return shape;
	}
	
}
