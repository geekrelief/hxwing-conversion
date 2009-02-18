/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.border;
	
import Import_org_aswing_graphics;
import Import_org_aswing;
import Import_org_aswing_geom;
import flash.display.DisplayObject;
import org.aswing.plaf.UIResource;
import org.aswing.plaf.ComponentUI;

/**
 * @private
 */
class TableHeaderCellBorder implements org.aswing.Border, implements org.aswing.plaf.UIResource {
	
	var shadow:ASColor;
    var darkShadow:ASColor;
    var highlight:ASColor;
    var lightHighlight:ASColor;
    
	public function new(){
	}
	
	function reloadColors(ui:ComponentUI):Void{
		shadow = ui.getColor("Button.shadow");
		darkShadow = ui.getColor("Button.darkShadow");
		highlight = ui.getColor("Button.light");
		lightHighlight = ui.getColor("Button.highlight");
	}
	
	public function updateBorder(c:Component, g:Graphics2D, b:IntRectangle):Void{
		if(shadow == null){
			reloadColors(c.getUI());
		}
		var pen:Pen = new Pen(darkShadow, 1);
		g.drawLine(pen, b.x+b.width-0.5, b.y+4, b.x+b.width-0.5, Math.max(b.y+b.height-2, b.y+4));
		g.fillRectangle(new SolidBrush(darkShadow), b.x, b.y+b.height-1, b.width, 1);
	}
	
	public function getBorderInsets(com:Component, bounds:IntRectangle):Insets
	{
		return new Insets(0, 0, 1, 1);
	}
	
	public function getDisplay(c:Component):DisplayObject
	{
		return null;
	}
	
}
