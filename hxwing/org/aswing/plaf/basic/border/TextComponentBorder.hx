/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.border;
	
import Import_org_aswing_graphics;
import org.aswing.geom.IntRectangle;
import Import_org_aswing;
import flash.display.DisplayObject;
import Import_org_aswing_plaf;
import org.aswing.error.ImpMissError;

/**
 * @private
 */
class TextComponentBorder implements org.aswing.Border, implements org.aswing.plaf.UIResource {
    

    var light:ASColor;
    var shadow:ASColor;
    	
	public function new(){
		
	}
	
    function getPropertyPrefix():String {
    	throw new ImpMissError();
        return "";
    }
	
	function reloadColors(ui:ComponentUI):Void{
		light = ui.getColor(getPropertyPrefix()+"light");
		shadow = ui.getColor(getPropertyPrefix()+"shadow");
	}
    	
	public function updateBorder(c:Component, g:Graphics2D, r:IntRectangle):Void
	{
		if(light == null){
			reloadColors(c.getUI());
		}
	    var x1:Int = r.x;
		var y1:Int = r.y;
		var w:Int = r.width;
		var h:Int = r.height;
		var textCom:EditableComponent = EditableComponent(c);
		if(textCom.isEditable() && c.isEnabled()){
			g.drawRectangle(new Pen(shadow, 1), x1+0.5, y1+0.5, w-1, h-1);
		}
		g.drawRectangle(new Pen(light, 1), x1+1.5, y1+1.5, w-3, h-3);		
	}
	
	public function getBorderInsets(com:Component, bounds:IntRectangle):Insets
	{
		return new Insets(2, 2, 2, 2);
	}
	
	public function getDisplay(c:Component):DisplayObject
	{
		return null;
	}
	
}
