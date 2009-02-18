/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.border;

	
import Import_org_aswing;
import Import_org_aswing_graphics;
import Import_org_aswing_geom;
import Import_flash_display;

/**
 * A border that draw a line at one side of a component.
 * @author iiley
 */	
class SideLineBorder extends DecorateBorder {
	
    /**
     * The north side constraint (top of component).
     */
    
	
    /**
     * The north side constraint (top of component).
     */
    public static var NORTH:Int  = 0;

    /**
     * The south side constraint (bottom of component).
     */
    public static var SOUTH:Int  = 1;

    /**
     * The east side constraint (right side of component).
     */
    public static var EAST:Int  = 2;

    /**
     * The west side constraint (left side of component).
     */
    public static var WEST:Int  = 3;
	
	var side:Int;
	var color:ASColor;
	var thickness:Float;
	
	/**
	 * SideLineBorder(interior:Border, side:Number, color:ASColor, thickness:Number) <br>
	 * SideLineBorder(interior:Border, side:Number, color:ASColor) <br>
	 * SideLineBorder(interior:Border, side:Number) <br>
	 * SideLineBorder(interior:Border) <br>
	 * SideLineBorder() <br>
	 * <p>
	 * @param interior interior border. Default is null;
	 * @param side the side of the line. Must be one of bottom value:
	 * <ul>
	 *   <li>#NORTH
	 *   <li>#SOUTH
	 *   <li>#EAST
	 *   <li>#WEST
	 * </ul>
	 * .Default is NORTH.
	 * @param color the color of the border. Default is ASColor.BLACK
	 * @param thickness the thickness of the border. Default is 1
	 */
	public function new(?interior:Border=null, ?side:Int=NORTH, ?color:ASColor=null, ?thickness:Int=1) {
		super(interior);
		if (color == null) color = ASColor.BLACK;
		
		this.side = side;
		this.color = color;
		this.thickness = thickness;
	}

	public override function updateBorderImp(com:Component, g:Graphics2D, b:IntRectangle):Void{
 		var pen:Pen = new Pen(color, thickness);
 		var x1:Float, x2:Float, y1:Float, y2:Float;
 		if(side == SOUTH){
 			x1 = b.x;
 			y1 = b.y + b.height - thickness/2;
 			x2 = b.x + b.width;
 			y2 = y1;
 		}else if(side == EAST){
 			x1 = b.x + b.width - thickness/2;
 			y1 = b.y;
 			x2 = x1;
 			y2 = b.y + b.height;
 		}else if(side == WEST){
 			x1 = b.x + thickness/2;
 			y1 = b.y;
 			x2 = x1;
 			y2 = b.y + b.height;
 		}else{
 			x1 = b.x;
 			y1 = b.y + thickness/2;
 			x2 = b.x + b.width;
 			y2 = y1;
 		}
 		g.drawLine(pen, x1, y1, x2, y2);
	}
    
    public override function getBorderInsetsImp(c:Component, bounds:IntRectangle):Insets{
    	var i:Insets = new Insets();
 		if(side == SOUTH){
 			i.bottom = thickness;
 		}else if(side == EAST){
 			i.right = thickness;
 		}else if(side == WEST){
 			i.left = thickness;
 		}else{
 			i.top = thickness;
 		}
    	return i;
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

	public function getSide():Float {
		return side;
	}

	public function setSide(side:Float):Void {
		this.side = side;
	}
}

