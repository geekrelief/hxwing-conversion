package org.aswing.plaf.basic.background;

	
import flash.display.DisplayObject;

import Import_org_aswing;
import org.aswing.geom.IntRectangle;
import Import_org_aswing_graphics;
import org.aswing.plaf.basic.BasicGraphicsUtils;
import Import_org_aswing_plaf;

/**
 * @private
 */
class ToggleButtonBackground implements org.aswing.GroundDecorator, implements org.aswing.plaf.UIResource {
    
    var shadow:ASColor;
    var darkShadow:ASColor;
    var highlight:ASColor;
    var lightHighlight:ASColor;
    
	public function new(){
	} 
	

	function reloadColors(ui:ComponentUI):Void{
		shadow = ui.getColor("ToggleButton.shadow");
		darkShadow = ui.getColor("ToggleButton.darkShadow");
		highlight = ui.getColor("ToggleButton.light");
		lightHighlight = ui.getColor("ToggleButton.highlight");
	}
	
	public function updateDecorator(c:Component, g:Graphics2D, bounds:IntRectangle):Void{
		if(shadow == null){
			reloadColors(c.getUI());
		}
		var b:AbstractButton = cast( c, AbstractButton);
		bounds = bounds.clone();
		if(b == null) return;
		if(c.isOpaque()){
			var model:ButtonModel = b.getModel();
	    	var isPressing:Bool = model.isArmed() || model.isSelected();
			BasicGraphicsUtils.drawBezel(g, bounds, isPressing, shadow, darkShadow, highlight, lightHighlight);
			bounds.grow(-2, -2);
			
			var bgColor:ASColor = (c.getBackground() == null ? ASColor.WHITE : c.getBackground());
			if(model.isArmed() || model.isSelected()){
				g.fillRectangle(new SolidBrush(bgColor.darker(0.9)), bounds.x, bounds.y, bounds.width, bounds.height);
			}else{
				BasicGraphicsUtils.paintButtonBackGround(b, g, bounds);
			}
		}
	}
	
	public function getDisplay(c:Component):DisplayObject
	{
		return null;
	}
		
}
