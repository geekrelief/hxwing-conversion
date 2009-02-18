/*
 Copyright aswing.org, see the LICENCE.txt.
*/


package org.aswing.plaf.basic.icon;

	
import Import_org_aswing;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;

/**
 * The icon for frame close.
 * @author iiley
 * @private
 */
class FrameCloseIcon extends FrameIcon {
	
	public function new(){
		super();
	}
	
	public override function updateIconImp(c:Component, g:Graphics2D, x:Int, y:Int):Void
	{
		var w:Int = Std.int(width/2);
		g.drawLine(
			new Pen(getColor(c), Std.int(w/3)), 
			x+(width-w)/2, y+(width-w)/2,
			x+(width+w)/2, y+(width+w)/2);
		g.drawLine(
			new Pen(getColor(c), Std.int(w/3)), 
			x+(width-w)/2, y+(width+w)/2,
			x+(width+w)/2, y+(width-w)/2);		
	}	
	
	public override function getIconWidth(c:Component):Int{
		return super.getIconWidth(c) + 2;
	}
}
