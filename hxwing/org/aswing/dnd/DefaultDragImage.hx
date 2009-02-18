/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.dnd;

import Import_flash_display;
import Import_org_aswing;
import Import_org_aswing_graphics;

/**
 * The default drag image.
 * @author iiley
 */
class DefaultDragImage implements DraggingImage {
	
	
	
	var image:Shape;
	var width:Int;
	var height:Int;
	
	public function new(dragInitiator:Component){
		width = dragInitiator.width;
		height = dragInitiator.height;
		
		image = new Shape();
	}
	
	public function getDisplay():DisplayObject
	{
		return image;
	}
	
	public function switchToRejectImage():Void
	{
		image.graphics.clear();
		var r:Int = Std.int(Math.min(width, height) - 2);
		var x:Int = 0;
		var y:Int = 0;
		var w:Int = width;
		var h:Int = height;
		var g:Graphics2D = new Graphics2D(image.graphics);
		g.drawLine(new Pen(ASColor.RED, 2), x+1, y+1, x+1+r, y+1+r);
		g.drawLine(new Pen(ASColor.RED, 2), x+1+r, y+1, x+1, y+1+r);
		g.drawRectangle(new Pen(ASColor.GRAY), x, y, w, h);
	}
	
	public function switchToAcceptImage():Void
	{
		image.graphics.clear();
		var g:Graphics2D = new Graphics2D(image.graphics);
		g.drawRectangle(new Pen(ASColor.GRAY), 0, 0, width, height);
	}
	
}
