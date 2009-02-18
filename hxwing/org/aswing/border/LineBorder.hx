/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.border;

import Import_org_aswing;
import Import_org_aswing_graphics;
import Import_org_aswing_geom;
import Import_flash_display;

/**
 * Line border, this will paint a rounded line for a component.
 */
class LineBorder extends DecorateBorder {
	
	
	
	var color:ASColor;
	var thickness:Int;
	var round:Int;
	
	/**
	 * Create a line border.
	 * @param interior interior border. Default is null;
	 * @param color the color of the border. Default is null, means ASColor.BLACK
	 * @param thickness the thickness of the border. Default is 1
	 * @param round round rect radius, default is 0 means normal rectangle, not rect.
	 */	
	public function new(?interior:Border=null, ?color:ASColor=null, ?thickness:Int=1, ?round:Int=0)
	{
		super(interior);
		if(color == null) color = ASColor.BLACK;
		
		this.color = color;
		this.thickness = thickness;
		this.round = round;
	}
	
	public override function updateBorderImp(com:Component, g:Graphics2D, b:IntRectangle):Void
	{
 		var t:Int = thickness;
    	if(round <= 0){
    		g.drawRectangle(new Pen(color, thickness), b.x + t/2, b.y + t/2, b.width - t, b.height - t);
    	}else{
    		g.fillRoundRectRingWithThickness(new SolidBrush(color), b.x, b.y, b.width, b.height, round, t);
    	}
	}
	
	public override function getBorderInsetsImp(com:Component, bounds:IntRectangle):Insets
	{
    	var width:Float = Math.ceil(thickness + round - round*0.707106781186547); //0.707106781186547 = Math.sin(45 degrees);
    	return new Insets(width, width, width, width);
	}
	
	public override function getDisplayImp():DisplayObject
	{
		return null;
	}

	public function getColor():ASColor {
		return color;
	}

	public function setColor(color:ASColor):Void {
		this.color = color;
	}

	public function getThickness():Float {
		return thickness;
	}

	public function setThickness(thickness:Float):Void {
		this.thickness = thickness;
	}

	public function getRound():Float {
		return round;
	}

	public function setRound(round:Float):Void {
		this.round = round;
	}    	
}
