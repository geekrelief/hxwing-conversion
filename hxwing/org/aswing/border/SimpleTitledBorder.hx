/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.border;

	
/**
 * A poor Title Border.
 * @author iiley
 */
import Import_flash_display;
import Import_flash_text;

import Import_org_aswing;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import org.aswing.util.HashMap;

class SimpleTitledBorder extends DecorateBorder {
	
	
	
	public static var TOP:Int = AsWingConstants.TOP;
	public static var BOTTOM:Int = AsWingConstants.BOTTOM;
	
	public static var CENTER:Int = AsWingConstants.CENTER;
	public static var LEFT:Int = AsWingConstants.LEFT;
	public static var RIGHT:Int = AsWingConstants.RIGHT;
	

    // Space between the border and the component's edge
    public static var EDGE_SPACING:Int = 0;	
	
	var title:String;
	var position:Int;
	var align:Int;
	var offset:Int;
	var font:ASFont;
	var color:ASColor;
	
	var textField:TextField;
	var textFieldSize:IntDimension;
	var colorFontValid:Bool;
	
	/**
	 * Create a simple titled border.
	 * @param title the title text string.
	 * @param position the position of the title(TOP or BOTTOM), default is TOP
	 * @see #TOP
	 * @see #BOTTOM
	 * @param align the align of the title(CENTER or LEFT or RIGHT), default is CENTER
	 * @see #CENTER
	 * @see #LEFT
	 * @see #RIGHT
	 * @param offset the addition of title text's x position, default is 0
	 * @param font the title text's ASFont
	 * @param color the color of the title text
	 * @see org.aswing.border.TitledBorder
	 */
	public function new(?interior:Border=null, ?title:String="", ?position:Int=AsWingConstants.TOP, ?align:Int=CENTER, ?offset:Int=0, ?font:ASFont=null, ?color:ASColor=null){
		super(interior);
		this.title = title;
		this.position = position;
		this.align = align;
		this.offset = offset;
		this.font = (font==null ? UIManager.getFont("systemFont") : font);
		this.color = (color==null ? ASColor.BLACK : color);
		textField = null;
		colorFontValid = false;
		textFieldSize = null;
	}
	
	
	//------------get set-------------
	
		
	public function getPosition():Int {
		return position;
	}

	public function setPosition(position:Int):Void {
		this.position = position;
	}

	public function getColor():ASColor {
		return color;
	}

	public function setColor(color:ASColor):Void {
		this.color = color;
		this.invalidateColorFont();
	}

	public function getFont():ASFont {
		return font;
	}

	public function setFont(font:ASFont):Void {
		this.font = font;
		invalidateColorFont();
		invalidateExtent();
	}

	public function getAlign():Int {
		return align;
	}

	public function setAlign(align:Int):Void {
		this.align = align;
	}

	public function getTitle():String {
		return title;
	}

	public function setTitle(title:String):Void {
		this.title = title;
		this.invalidateExtent();
		this.invalidateColorFont();
	}

	public function getOffset():Int {
		return offset;
	}

	public function setOffset(offset:Int):Void {
		this.offset = offset;
	}
	
	function invalidateExtent():Void{
		textFieldSize = null;
	}
	function invalidateColorFont():Void{
		colorFontValid = false;
	}
	
	function getTextFieldSize():IntDimension{
    	if (textFieldSize == null){
	    	var tf:TextFormat = getFont().getTextFormat();
			textFieldSize = AsWingUtils.computeStringSize(tf, title);   	
    	}
    	return textFieldSize;
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
    	if(!colorFontValid){
    		textField.text = title;
    		AsWingUtils.applyTextFontAndColor(textField, font, color);
    		colorFontValid = true;
    	}
    	
    	var width:Int = Math.ceil(textField.width);
    	var height:Int = Math.ceil(textField.height);
    	var x:Int = offset;
    	if(align == LEFT){
    		x += bounds.x;
    	}else if(align == RIGHT){
    		x += (bounds.x + bounds.width - width);
    	}else{
    		x += (bounds.x + bounds.width/2 - width/2);
    	}
    	var y:Int = bounds.y + EDGE_SPACING;
    	if(position == BOTTOM){
    		y = bounds.y + bounds.height - height + EDGE_SPACING;
    	}
    	textField.x = x;
    	textField.y = y;
    }
    	   
    public override function getBorderInsetsImp(c:Component, bounds:IntRectangle):Insets{
    	var insets:Insets = new Insets();
    	var cs:IntDimension = bounds.getSize();
		if(cs.width < getTextFieldSize().width){
			var delta:Int = Math.ceil(getTextFieldSize().width) - cs.width;
			if(align == RIGHT){
				insets.left = delta;
			}else if(align == CENTER){
				insets.left = delta/2;
				insets.right = delta/2;
			}else{
				insets.right = delta;
			}
		}
    	if(position == BOTTOM){
    		insets.bottom = EDGE_SPACING*2 + Math.ceil(getTextFieldSize().height);
    	}else{
    		insets.top = EDGE_SPACING*2 + Math.ceil(getTextFieldSize().height);
    	}
    	return insets;
    }
	
	public override function getDisplayImp():DisplayObject
	{
		return getTextField();
	}	
}
