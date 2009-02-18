/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon;


import flash.display.DisplayObject;

import Import_org_aswing;
import Import_org_aswing_graphics;
import org.aswing.plaf.ComponentUI;
import org.aswing.plaf.UIResource;
import flash.geom.Matrix;

/**
 * @private
 */
class RadioButtonIcon implements org.aswing.Icon, implements UIResource {
	
	var shadow:ASColor;
    var darkShadow:ASColor;
    var highlight:ASColor;
    var lightHighlight:ASColor;
	
	public function new(){
	}
	
	function reloadColors(ui:ComponentUI):Void{
		shadow = ui.getColor("RadioButton.shadow");
		darkShadow = ui.getColor("RadioButton.darkShadow");
		highlight = ui.getColor("RadioButton.light");
		lightHighlight = ui.getColor("RadioButton.highlight");
	}
	
	public function updateIcon(c:Component, g:Graphics2D, x:Int, y:Int):Void{
		if(shadow == null){
			reloadColors(c.getUI());
		}
		var rb:AbstractButton = cast(c, AbstractButton);
		var model:ButtonModel = rb.getModel();
		var drawDot:Bool = model.isSelected();
		
		var periphery:ASColor = darkShadow;
		var middle:ASColor = highlight;
		var inner:ASColor = shadow;
		var dot:ASColor = rb.getForeground();
		
		// Set up colors per RadioButtonModel condition
		if (!model.isEnabled()) {
			periphery = middle = inner = rb.getBackground();
			dot = darkShadow;
		} else if (model.isPressed()) {
			periphery = shadow;
			inner = darkShadow;
		}
		
		var w:Int = getIconWidth(c);
		var h:Int = getIconHeight(c);
		var cx:Int = Std.int(x + w/2);
		var cy:Int = Std.int(y + h/2);
		var xr:Int = Std.int(w/2);
		var yr:Int = Std.int(h/2);
		
		var brush:SolidBrush = new SolidBrush(darkShadow);
		g.fillEllipse(brush, x, y, w, h);
		brush.setColor(highlight);
		g.fillEllipse(brush, x+1, y+1, w-2, h-2);
        
        var colors:Array<Dynamic> = [rb.getBackground().getRGB(), 0xffffff];
		var alphas:Array<Dynamic> = [1, 1];
		var ratios:Array<Dynamic> = [0, 255];
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox(w-3, h-3, (45/180)*Math.PI, x+2, y+2);    
	    var gbrush:GradientBrush = new GradientBrush(GradientBrush.LINEAR, colors, alphas, ratios, matrix);
	    g.fillEllipse(gbrush, x+2, y+2, w-4, h-4);
		
		if(drawDot){
			xr = Std.int(w/5);
			yr = Std.int(h/5);
			brush = new SolidBrush(dot);
			g.fillEllipse(brush, cx-xr, cy-yr, xr*2, yr*2);			
		}
	}
	
	public function getIconHeight(c:Component):Int{
		return 13;
	}
	
	public function getIconWidth(c:Component):Int{
		return 13;
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return null;
	}
	
}
