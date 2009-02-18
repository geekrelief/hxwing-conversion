/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon;

import Import_org_aswing_graphics;
import org.aswing.Icon;
import org.aswing.Component;
import Import_flash_display;
import Import_org_aswing_plaf;
import org.aswing.plaf.basic.BasicGraphicsUtils;
import org.aswing.ASColor;
import org.aswing.geom.IntRectangle;

/**
 * @private
 */
class SliderThumbIcon implements org.aswing.Icon, implements org.aswing.plaf.UIResource {
	
	
	
	var thumb:Sprite;
	var enabledButton:SimpleButton;
	var disabledButton:SimpleButton;
	
	var thumbLightHighlightColor:ASColor;
	var thumbHighlightColor:ASColor;
	var thumbLightShadowColor:ASColor;
	var thumbDarkShadowColor:ASColor;
	var thumbColor:ASColor;
	
	public function new(){
		thumb = new Sprite();
	}
	
	function getPropertyPrefix():String {
		return "Slider.";
	}	
	
	function initThumb(ui:ComponentUI):Void{
		var pp:String = getPropertyPrefix();
		thumbHighlightColor = ui.getColor(pp+"thumbHighlight");
		thumbLightHighlightColor = ui.getColor(pp+"thumbLightHighlight");
		thumbLightShadowColor = ui.getColor(pp+"thumbShadow");
		thumbDarkShadowColor = ui.getColor(pp+"thumbDarkShadow");
		thumbColor = ui.getColor(pp+"thumb");
		
		//enabled
		enabledButton = new SimpleButton();
		var upState:Shape = new Shape();
		var g:Graphics2D = new Graphics2D(upState.graphics);
    	
    	var borderC:ASColor = thumbDarkShadowColor;
    	var fillC:ASColor = thumbColor;
    	paintThumb(g, borderC, fillC, true);
    	enabledButton.upState = upState; 
		enabledButton.overState = upState;
		enabledButton.downState = upState;
		enabledButton.hitTestState = upState;
		enabledButton.useHandCursor = false;
		thumb.addChild(enabledButton);
		
		//disabled
		disabledButton = new SimpleButton();
		upState = new Shape();
		g = new Graphics2D(upState.graphics);
    	
    	borderC = thumbColor;
    	fillC = thumbColor;
    	paintThumb(g, borderC, fillC, false);
    	disabledButton.upState = upState; 
		disabledButton.overState = upState;
		disabledButton.downState = upState;
		disabledButton.hitTestState = upState;
		disabledButton.useHandCursor = false;
		thumb.addChild(disabledButton);
		disabledButton.visible = false;
	}
	
	function paintThumb(g:Graphics2D, borderC:ASColor, fillC:ASColor, enabled:Bool):Void{
		if(!enabled){
	    	g.beginDraw(new Pen(borderC));
	    	g.beginFill(new SolidBrush(fillC));
	    	g.rectangle(1, 1, getIconWidth(null)-2, getIconHeight(null)-2);
	    	g.endFill();
	    	g.endDraw();
		}else{
    		BasicGraphicsUtils.drawControlBackground(
    			g, 
    			new IntRectangle(0, 0, getIconWidth(null), getIconHeight(null)), 
    			fillC,
    			0);
			g.drawRectangle(new Pen(borderC), 0.5, 0.5, getIconWidth(null)-1, getIconHeight(null)-1);
		}
	}
	
	public function updateIcon(c:Component, g:Graphics2D, x:Int, y:Int):Void
	{
		if(thumbColor == null){
			initThumb(c.getUI());
		}
		thumb.x = x;
		thumb.y = y;
		disabledButton.visible = !c.isEnabled();
		enabledButton.visible = c.isEnabled();
	}
	
	public function getIconHeight(c:Component):Int
	{
		return 18;
	}
	
	public function getIconWidth(c:Component):Int
	{
		return 8;
	}
	
	public function getDisplay(c:Component):DisplayObject
	{
		return thumb;
	}
	
}
