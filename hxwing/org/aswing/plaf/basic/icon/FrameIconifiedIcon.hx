/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon;

import Import_org_aswing;
import Import_org_aswing_graphics;
import Import_org_aswing_geom;

/**
 * The icon for frame iconified.
 * @author iiley
 * @private
 */
class FrameIconifiedIcon extends FrameIcon {
	
	
	
	public function new()
	{
		super();
	}
	
	public override function updateIconImp(c:Component, g:Graphics2D, x:Int, y:Int):Void
	{
		var w:Int = Std.int(width/2);
		var h:Int = Std.int(w/3);
		g.fillRectangle(new SolidBrush(getColor(c)), x+h, y+w+h, w, h);	
	}	
}
