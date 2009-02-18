/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon;
	
import Import_flash_display;
import Import_org_aswing;
import Import_org_aswing_graphics;

/**
 * @private
 */
class CheckBoxMenuItemCheckIcon extends MenuCheckIcon {
	
	
	
	var shape:Shape;
	
	public function new(){
        super();
		shape = new Shape();
	}
	
	public override function updateIcon(c:Component, g:Graphics2D, x:Int, y:Int):Void{
		shape.graphics.clear();
		g = new Graphics2D(shape.graphics);
		var menu:AbstractButton = cast(c, AbstractButton);
		if(menu.isSelected()){
			g.beginDraw(new Pen(ASColor.BLACK, 2));
			g.moveTo(x, y+4);
			g.lineTo(x+3, y+7);
			g.lineTo(x+7, y+2);
			g.endDraw();
		}
	}
	
	public override function getDisplay(c:Component):DisplayObject{
		return shape;
	}
}
