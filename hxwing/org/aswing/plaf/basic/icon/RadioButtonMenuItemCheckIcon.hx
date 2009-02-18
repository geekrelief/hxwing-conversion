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
class RadioButtonMenuItemCheckIcon extends MenuCheckIcon {
	
	
	
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
			g.fillCircle(new SolidBrush(ASColor.BLACK), x+4, y+5, 3);
		}
	}
	
	public override function getDisplay(c:Component):DisplayObject{
		return shape;
	}
}
