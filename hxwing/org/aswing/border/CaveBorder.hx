/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.border;

import Import_flash_display;
import Import_flash_text;

import Import_org_aswing;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import org.aswing.util.HashMap;

/**
 * CaveBorder, a border with a cave line rectangle(or roundrect).
 * It is like a TitledBorder with no title. :)
 */
class CaveBorder extends DecorateBorder {
	
	
	
	public var DEFAULT_LINE_COLOR(getDEFAULT_LINE_COLOR, null) : ASColor;
	
	public var DEFAULT_LINE_LIGHT_COLOR(getDEFAULT_LINE_LIGHT_COLOR, null) : ASColor;
	
	public static function getDEFAULT_LINE_COLOR():ASColor{
		return ASColor.GRAY;
	}
	public static function getDEFAULT_LINE_LIGHT_COLOR():ASColor{
		return ASColor.WHITE;
	}
	public static var DEFAULT_LINE_THICKNESS:Int = 1;
				
	var round:Float;
	var lineColor:ASColor;
	var lineLightColor:ASColor;
	var lineThickness:Float;
	var beveled:Bool;
	
	/**
	 * Create a cave border.
	 * @param interior the interior border.
	 * @param round round rect radius, default is 0 means normal rectangle, not rect.
	 * @see org.aswing.border.TitledBorder
	 * @see #setLineColor()
	 * @see #setLineThickness()
	 * @see #setBeveled()
	 */
	public function new(?interior:Border=null, ?round:Int=0){
		super(interior);
		this.round = round;
		
		lineColor = DEFAULT_LINE_COLOR;
		lineLightColor = DEFAULT_LINE_LIGHT_COLOR;
		lineThickness = DEFAULT_LINE_THICKNESS;
		beveled = true;
	}
	
	public override function updateBorderImp(c:Component, g:Graphics2D, bounds:IntRectangle):Void{
    	var x1:Float = bounds.x + lineThickness*0.5;
    	var y1:Float = bounds.y + lineThickness*0.5;
    	var w:Int = bounds.width - lineThickness;
    	var h:Int = bounds.height - lineThickness;
    	if(beveled){
    		w -= lineThickness;
    		h -= lineThickness;
    	}
    	var x2:Int = x1 + w;
    	var y2:Int = y1 + h;
    	
    	var textR:IntRectangle = new IntRectangle(bounds.x+bounds.width/2, bounds.y, 0, 0);
    	
    	var pen:Pen = new Pen(lineColor, lineThickness);
    	if(round <= 0){
			//draw dark rect
			g.beginDraw(pen);
			g.moveTo(x1, y1);
			g.lineTo(x1, y2);
			g.lineTo(x2, y2);
			g.lineTo(x2, y1);
			g.lineTo(x1, y1);
			g.endDraw();
			if(beveled){
    			//draw hightlight
    			pen.setColor(lineLightColor);
    			g.beginDraw(pen);
    			g.moveTo(x1+lineThickness, y1+lineThickness);
    			g.lineTo(x1+lineThickness, y2-lineThickness);
    			g.moveTo(x1, y2+lineThickness);
    			g.lineTo(x2+lineThickness, y2+lineThickness);
    			g.lineTo(x2+lineThickness, y1);
    			g.moveTo(x2-lineThickness, y1+lineThickness);
    			g.lineTo(x1+lineThickness, y1+lineThickness);
    			g.endDraw();
			}
    	}else{
			var r:Int = round;
			if(beveled){
				pen.setColor(lineLightColor);
    			g.beginDraw(pen);
    			var t:Int = lineThickness;
				x1+=t;
				x2+=t;
				y1+=t;
				y2+=t;
	    		g.moveTo(textR.x, y1);
				//Top left
				g.lineTo (x1+r, y1);
				g.curveTo(x1, y1, x1, y1+r);
				//Bottom left
				g.lineTo (x1, y2-r );
				g.curveTo(x1, y2, x1+r, y2);
				//bottom right
				g.lineTo(x2-r, y2);
				g.curveTo(x2, y2, x2, y2-r);
				//Top right
				g.lineTo (x2, y1+r);
				g.curveTo(x2, y1, x2-r, y1);
				g.lineTo(textR.x + textR.width, y1);
    			g.endDraw();  
				x1-=t;
				x2-=t;
				y1-=t;
				y2-=t;  				
			}		
			pen.setColor(lineColor);		
			g.beginDraw(pen);
    		g.moveTo(textR.x, y1);
			//Top left
			g.lineTo (x1+r, y1);
			g.curveTo(x1, y1, x1, y1+r);
			//Bottom left
			g.lineTo (x1, y2-r );
			g.curveTo(x1, y2, x1+r, y2);
			//bottom right
			g.lineTo(x2-r, y2);
			g.curveTo(x2, y2, x2, y2-r);
			//Top right
			g.lineTo (x2, y1+r);
			g.curveTo(x2, y1, x2-r, y1);
			g.lineTo(textR.x + textR.width, y1);
			g.endDraw();
		}	
    }
    	   
   public override function getBorderInsetsImp(c:Component, bounds:IntRectangle):Insets{
    	var cornerW:Float = Math.ceil(lineThickness*2 + round - round*0.707106781186547);
    	var insets:Insets = new Insets(cornerW, cornerW, cornerW, cornerW);
    	return insets;
    }
	
	public override function getDisplayImp():DisplayObject{
		return null;
	}		
	
	//-----------------------------------------------------------------
	public function getLineColor():ASColor {
		return lineColor;
	}

	public function setLineColor(lineColor:ASColor):Void {
		if (lineColor != null){
			this.lineColor = lineColor;
		}
	}
	
	public function getLineLightColor():ASColor{
		return lineLightColor;
	}
	
	public function setLineLightColor(lineLightColor:ASColor):Void{
		if (lineLightColor != null){
			this.lineLightColor = lineLightColor;
		}
	}
	
	public function isBeveled():Bool{
		return beveled;
	}
	
	public function setBeveled(b:Bool):Void{
		beveled = b;
	}

	public function getRound():Float {
		return round;
	}

	public function setRound(round:Float):Void {
		this.round = round;
	}
	
	public function getLineThickness():Int {
		return lineThickness;
	}

	public function setLineThickness(lineThickness:Float):Void {
		this.lineThickness = lineThickness;
	}
}
	
