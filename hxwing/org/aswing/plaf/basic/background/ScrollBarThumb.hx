/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.background;

	
import Import_org_aswing_graphics;
import Import_org_aswing;
import org.aswing.geom.IntRectangle;
import flash.display.DisplayObject;
import Import_org_aswing_plaf;
import flash.display.Sprite;
import org.aswing.geom.IntDimension;
import Import_flash_events;
import Import_org_aswing_event;
import org.aswing.plaf.basic.BasicGraphicsUtils;

/**
 * The thumb decorator for JScrollBar.
 * @author iiley
 * @private
 */
class ScrollBarThumb implements org.aswing.GroundDecorator, implements org.aswing.plaf.UIResource {
	
	var thumbHighlightColor:ASColor;
    var thumbLightHighlightColor:ASColor;
    var thumbLightShadowColor:ASColor;
    var thumbDarkShadowColor:ASColor;
    var thumbColor:ASColor;
    var thumb:AWSprite;
    var size:IntDimension;
    var verticle:Bool;
        
	var rollover:Bool;
	var pressed:Bool;
    
	public function new(){
		thumb = new AWSprite();
		rollover = false;
		pressed = false;
		initSelfHandlers();
	}
	
	function reloadColors(ui:ComponentUI):Void{
		thumbHighlightColor = ui.getColor("ScrollBar.thumbHighlight");
		thumbLightHighlightColor = ui.getColor("ScrollBar.thumbLightHighlight");
		thumbLightShadowColor = ui.getColor("ScrollBar.thumbShadow");
		thumbDarkShadowColor = ui.getColor("ScrollBar.thumbDarkShadow");
		thumbColor = ui.getColor("ScrollBar.thumbBackground");
	}
	
	public function updateDecorator(c:Component, g:Graphics2D, bounds:IntRectangle):Void{
		if(thumbColor == null){
			reloadColors(c.getUI());
		}
		thumb.x = bounds.x;
		thumb.y = bounds.y;
		size = bounds.getSize();
		var sb:JScrollBar = JScrollBar(c);
		verticle = (sb.getOrientation() == JScrollBar.VERTICAL);
		paint();
	}
	
	function paint():Void{
    	var w:Int = size.width;
    	var h:Int = size.height;
    	thumb.graphics.clear();
    	var g:Graphics2D = new Graphics2D(thumb.graphics);
    	var rect:IntRectangle = new IntRectangle(0, 0, w, h);
    	
    	if(pressed){
    		g.fillRectangle(new SolidBrush(thumbColor), rect.x, rect.y, rect.width, rect.height);
    	}else{
	    	BasicGraphicsUtils.drawControlBackground(g, rect, thumbColor, 
	    		verticle ? 0 : Math.PI/2);
    	}
    	
    	BasicGraphicsUtils.drawBezel(g, rect, pressed, 
    		thumbLightShadowColor, 
    		thumbDarkShadowColor, 
    		thumbHighlightColor, 
    		thumbLightHighlightColor
    		);
    		
    		
    	var p:Pen = new Pen(thumbDarkShadowColor, 0);
    	if(verticle){
	    	var ch:Float = h/2.0;
	    	g.drawLine(p, 4, ch, w-4, ch);
	    	g.drawLine(p, 4, ch+2, w-4, ch+2);
	    	g.drawLine(p, 4, ch-2, w-4, ch-2);
    	}else{
	    	var cw:Float = w/2.0;
	    	g.drawLine(p, cw, 4, cw, h-4);
	    	g.drawLine(p, cw+2, 4, cw+2, h-4);
	    	g.drawLine(p, cw-2, 4, cw-2, h-4);
    	}		
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return thumb;
	}

	function initSelfHandlers():Void{
		thumb.addEventListener(MouseEvent.ROLL_OUT, __rollOutListener);
		thumb.addEventListener(MouseEvent.ROLL_OVER, __rollOverListener);
		thumb.addEventListener(MouseEvent.MOUSE_DOWN, __mouseDownListener);
		thumb.addEventListener(ReleaseEvent.RELEASE, __mouseUpListener);
	}
	
	function __rollOverListener(e:Event):Void{
		rollover = true;
		paint();
	}
	function __rollOutListener(e:Event):Void{
		rollover = false;
		if(!pressed){
			paint();
		}
	}
	function __mouseDownListener(e:Event):Void{
		pressed = true;
		paint();
	}
	function __mouseUpListener(e:Event):Void{
		if(pressed){
			pressed = false;
			paint();
		}
	}
}

