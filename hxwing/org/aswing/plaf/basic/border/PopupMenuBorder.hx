package org.aswing.plaf.basic.border;

import Import_org_aswing_geom;
import Import_org_aswing;
import Import_flash_display;
import Import_org_aswing_plaf;
import Import_org_aswing_graphics;

/**
 * @private
 */
class PopupMenuBorder implements org.aswing.Border, implements org.aswing.plaf.UIResource {
	
	
	
	var color:ASColor;
	
	public function new(){
	}
	
	public function updateBorder(c:Component, g:Graphics2D, bounds:IntRectangle):Void{
		if(color == null){
			color = c.getUI().getColor("PopupMenu.borderColor");
		}
		g.beginDraw(new Pen(color.changeAlpha(0.5), 4));
		g.moveTo(bounds.x + bounds.width - 2, bounds.y+8);
		g.lineTo(bounds.x + bounds.width - 2, bounds.y+bounds.height-2);
		g.lineTo(bounds.x + 8, bounds.y+bounds.height-2);
		g.endDraw();
		g.drawRectangle(new Pen(color, 1), 
			bounds.x+0.5, bounds.y+0.5, 
			bounds.width - 4,
			bounds.height - 4);
	}
	
	public function getBorderInsets(com:Component, bounds:IntRectangle):Insets{
		return new Insets(1, 1, 4, 4);
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return null;
	}
	
}
