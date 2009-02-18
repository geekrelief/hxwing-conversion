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
 * TitledBorder, a border with a line rectangle and a title text.
 * @author iiley
 */	
class TitledBorder extends DecorateBorder {
		
	
		
	public var DEFAULT_COLOR(getDEFAULT_COLOR, null) : ASColor;
		
	public var DEFAULT_FONT(getDEFAULT_FONT, null) : ASFont;
		
	public var DEFAULT_LINE_COLOR(getDEFAULT_LINE_COLOR, null) : ASColor;
		
	public var DEFAULT_LINE_LIGHT_COLOR(getDEFAULT_LINE_LIGHT_COLOR, null) : ASColor;
		
	public static function getDEFAULT_FONT():ASFont{
		return UIManager.getFont("systemFont");
	}
	public static function getDEFAULT_COLOR():ASColor{
		return ASColor.BLACK;
	}
	public static function getDEFAULT_LINE_COLOR():ASColor{
		return ASColor.GRAY;
	}
	public static function getDEFAULT_LINE_LIGHT_COLOR():ASColor{
		return ASColor.WHITE;
	}
	public static var DEFAULT_LINE_THICKNESS:Int = 1;
		
	public static var TOP:Int = AsWingConstants.TOP;
	public static var BOTTOM:Int = AsWingConstants.BOTTOM;
	
	public static var CENTER:Int = AsWingConstants.CENTER;
	public static var LEFT:Int = AsWingConstants.LEFT;
	public static var RIGHT:Int = AsWingConstants.RIGHT;
	

    // Space between the text and the line end
    public static var GAP:Int = 1;	
	
	var title:String;
	var position:Int;
	var align:Int;
	var edge:Float;
	var round:Float;
	var font:ASFont;
	var color:ASColor;
	var lineColor:ASColor;
	var lineLightColor:ASColor;
	var lineThickness:Float;
	var beveled:Bool;
	var textField:TextField;
	var textFieldSize:IntDimension;
	
	/**
	 * Create a titled border.
	 * @param title the title text string.
	 * @param position the position of the title(TOP or BOTTOM), default is TOP
	 * @param align the align of the title(CENTER or LEFT or RIGHT), default is CENTER
	 * @param edge the edge space of title position, defaut is 0.
	 * @param round round rect radius, default is 0 means normal rectangle, not rect.
	 * @see org.aswing.border.SimpleTitledBorder
	 * @see #setColor()
	 * @see #setLineColor()
	 * @see #setFont()
	 * @see #setLineThickness()
	 * @see #setBeveled()
	 */
	public function new(?interior:Border=null, ?title:String="", ?position:Int=AsWingConstants.TOP, ?align:Int=CENTER, ?edge:Int=0, ?round:Int=0){
		super(interior);
		this.title = title;
		this.position = position;
		this.align = align;
		this.edge = edge;
		this.round = round;
		
		font = DEFAULT_FONT;
		color = DEFAULT_COLOR;
		lineColor = DEFAULT_LINE_COLOR;
		lineLightColor = DEFAULT_LINE_LIGHT_COLOR;
		lineThickness = DEFAULT_LINE_THICKNESS;
		beveled = true;
		textField = null;
		textFieldSize = null;
	}
	
	function getTextField():TextField{
    	if(textField == null){
	    	textField = new TextField();
	    	textField.selectable = false;
	    	textField.autoSize = TextFieldAutoSize.CENTER;
    	}
    	return textField;
	}
	
	public override function updateBorderImp(c:Component, g:Graphics2D, bounds:IntRectangle):Void{
    	var textHeight:Int = Math.ceil(getTextFieldSize().height);
    	var x1:Float = bounds.x + lineThickness*0.5;
    	var y1:Float = bounds.y + lineThickness*0.5;
    	if(position == TOP){
    		y1 += textHeight/2;
    	}
    	var w:Int = bounds.width - lineThickness;
    	var h:Int = bounds.height - lineThickness - textHeight/2;
    	if(beveled){
    		w -= lineThickness;
    		h -= lineThickness;
    	}
    	var x2:Int = x1 + w;
    	var y2:Int = y1 + h;
    	
    	var textR:IntRectangle = new IntRectangle();
    	var viewR:IntRectangle = new IntRectangle(bounds.x, bounds.y, bounds.width, bounds.height);
    	var text:String = title;
        var verticalAlignment:Int = position;
        var horizontalAlignment:Int = align;
    	
    	var pen:Pen = new Pen(lineColor, lineThickness);
    	if(round <= 0){
    		if(bounds.width <= edge*2){
    			g.drawRectangle(pen, x1, y1, w, h);
    			if(beveled){
    				pen.setColor(lineLightColor);
    				g.beginDraw(pen);
    				g.moveTo(x1+lineThickness, y2-lineThickness);
    				g.lineTo(x1+lineThickness, y1+lineThickness);
    				g.lineTo(x2-lineThickness, y1+lineThickness);
    				g.moveTo(x2+lineThickness, y1);
    				g.lineTo(x2+lineThickness, y2+lineThickness);
    				g.lineTo(x1, y2+lineThickness);
    			}
    			textField.text="";
    		}else{
    			viewR.x += edge;
    			viewR.width -= edge*2;
    			text = AsWingUtils.layoutText(font, text, verticalAlignment, horizontalAlignment, viewR, textR);
    			//draw dark rect
    			g.beginDraw(pen);
    			if(position == TOP){
	    			g.moveTo(textR.x - GAP, y1);
	    			g.lineTo(x1, y1);
	    			g.lineTo(x1, y2);
	    			g.lineTo(x2, y2);
	    			g.lineTo(x2, y1);
	    			g.lineTo(textR.x + textR.width+GAP, y1);
	    				    			
    			}else{
	    			g.moveTo(textR.x - GAP, y2);
	    			g.lineTo(x1, y2);
	    			g.lineTo(x1, y1);
	    			g.lineTo(x2, y1);
	    			g.lineTo(x2, y2);
	    			g.lineTo(textR.x + textR.width+GAP, y2);
    			}
    			g.endDraw();
    			if(beveled){
	    			//draw hightlight
	    			pen.setColor(lineLightColor);
	    			g.beginDraw(pen);
	    			if(position == TOP){
		    			g.moveTo(textR.x - GAP, y1+lineThickness);
		    			g.lineTo(x1+lineThickness, y1+lineThickness);
		    			g.lineTo(x1+lineThickness, y2-lineThickness);
		    			g.moveTo(x1, y2+lineThickness);
		    			g.lineTo(x2+lineThickness, y2+lineThickness);
		    			g.lineTo(x2+lineThickness, y1);
		    			g.moveTo(x2-lineThickness, y1+lineThickness);
		    			g.lineTo(textR.x + textR.width+GAP, y1+lineThickness);
		    				    			
	    			}else{
		    			g.moveTo(textR.x - GAP, y2+lineThickness);
		    			g.lineTo(x1, y2+lineThickness);
		    			g.moveTo(x1+lineThickness, y2-lineThickness);
		    			g.lineTo(x1+lineThickness, y1+lineThickness);
		    			g.lineTo(x2-lineThickness, y1+lineThickness);
		    			g.moveTo(x2+lineThickness, y1);
		    			g.lineTo(x2+lineThickness, y2+lineThickness);
		    			g.lineTo(textR.x + textR.width+GAP, y2+lineThickness);
	    			}
	    			g.endDraw();
    			}
    		}
    	}else{
    		if(bounds.width <= (edge*2 + round*2)){
    			if(beveled){
    				g.drawRoundRect(new Pen(lineLightColor, lineThickness), 
    							x1+lineThickness, y1+lineThickness, w, h, 
    							Math.min(round, Math.min(w/2, h/2)));
    			}
    			g.drawRoundRect(pen, x1, y1, w, h, 
    							Math.min(round, Math.min(w/2, h/2)));
    			textField.text="";
    		}else{
    			viewR.x += (edge+round);
    			viewR.width -= (edge+round)*2;
    			text = AsWingUtils.layoutText(font, text, verticalAlignment, horizontalAlignment, viewR, textR);
				var r:Int = round;

    			if(beveled){
    				pen.setColor(lineLightColor);
	    			g.beginDraw(pen);
	    			var t:Int = lineThickness;
    				x1+=t;
    				x2+=t;
    				y1+=t;
    				y2+=t;
	    			if(position == TOP){
			    		g.moveTo(textR.x - GAP, y1);
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
						g.lineTo(textR.x + textR.width+GAP, y1);
	    			}else{
			    		g.moveTo(textR.x + textR.width+GAP, y2);
						//bottom right
						g.lineTo(x2-r, y2);
						g.curveTo(x2, y2, x2, y2-r);
						//Top right
						g.lineTo (x2, y1+r);
						g.curveTo(x2, y1, x2-r, y1);
						//Top left
						g.lineTo (x1+r, y1);
						g.curveTo(x1, y1, x1, y1+r);
						//Bottom left
						g.lineTo (x1, y2-r );
						g.curveTo(x1, y2, x1+r, y2);
						g.lineTo(textR.x - GAP, y2);
	    			}
	    			g.endDraw();  
    				x1-=t;
    				x2-=t;
    				y1-=t;
    				y2-=t;  				
    			}		
    			pen.setColor(lineColor);		
    			g.beginDraw(pen);
    			if(position == TOP){
		    		g.moveTo(textR.x - GAP, y1);
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
					g.lineTo(textR.x + textR.width+GAP, y1);
    			}else{
		    		g.moveTo(textR.x + textR.width+GAP, y2);
					//bottom right
					g.lineTo(x2-r, y2);
					g.curveTo(x2, y2, x2, y2-r);
					//Top right
					g.lineTo (x2, y1+r);
					g.curveTo(x2, y1, x2-r, y1);
					//Top left
					g.lineTo (x1+r, y1);
					g.curveTo(x1, y1, x1, y1+r);
					//Bottom left
					g.lineTo (x1, y2-r );
					g.curveTo(x1, y2, x1+r, y2);
					g.lineTo(textR.x - GAP, y2);
    			}
    			g.endDraw();
    		}
    	}
    	textField.text = text;
		AsWingUtils.applyTextFontAndColor(textField, font, color);
    	textField.x = textR.x;
    	textField.y = textR.y;   	
    }
    	   
   public override function getBorderInsetsImp(c:Component, bounds:IntRectangle):Insets{
    	var cornerW:Float = Math.ceil(lineThickness*2 + round - round*0.707106781186547);
    	var insets:Insets = new Insets(cornerW, cornerW, cornerW, cornerW);
    	if(position == BOTTOM){
    		insets.bottom += Math.ceil(getTextFieldSize().height);
    	}else{
    		insets.top += Math.ceil(getTextFieldSize().height);
    	}
    	return insets;
    }
	
	public override function getDisplayImp():DisplayObject
	{
		return getTextField();
	}		
	
	//-----------------------------------------------------------------

	public function getFont():ASFont {
		return font;
	}

	public function setFont(font:ASFont):Void {
		if(this.font != font){
			if(font == null) font = DEFAULT_FONT;
			this.font = font;
			textFieldSize == null;
		}
	}

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

	public function getEdge():Float {
		return edge;
	}

	public function setEdge(edge:Float):Void {
		this.edge = edge;
	}

	public function getTitle():String {
		return title;
	}

	public function setTitle(title:String):Void {
		if(this.title != title){
			this.title = title;
			textFieldSize == null;
		}
	}

	public function getRound():Float {
		return round;
	}

	public function setRound(round:Float):Void {
		this.round = round;
	}

	public function getColor():ASColor {
		return color;
	}

	public function setColor(color:ASColor):Void {
		this.color = color;
	}

	public function getAlign():Int {
		return align;
	}
	
	/**
	 * Sets the align of title text.
	 * @see #CENTER
	 * @see #LEFT
	 * @see #RIGHT
	 */
	public function setAlign(align:Int):Void {
		this.align = align;
	}

	public function getPosition():Int {
		return position;
	}
	
	/**
	 * Sets the position of title text.
	 * @see #TOP
	 * @see #BOTTOM
	 */
	public function setPosition(position:Int):Void {
		this.position = position;
	}	
	
	public function getLineThickness():Int {
		return lineThickness;
	}

	public function setLineThickness(lineThickness:Float):Void {
		this.lineThickness = lineThickness;
	}
		
	function getTextFieldSize():IntDimension{
    	if (textFieldSize == null){
			textFieldSize = getFont().computeTextSize(title);  	
    	}
    	return textFieldSize;
	}
}
