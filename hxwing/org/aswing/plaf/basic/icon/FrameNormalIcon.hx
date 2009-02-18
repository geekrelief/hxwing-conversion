/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon;

import Import_org_aswing;
import Import_org_aswing_graphics;
import Import_org_aswing_geom;

/**
 * The icon for frame normal.
 * @author iiley
 * @private
 */
class FrameNormalIcon extends FrameIcon {

	

	public function new(){
		super();
	}

	public override function updateIconImp(c:Component, g:Graphics2D, x:Int, y:Int):Void
	{
		var w:Int = Std.int(width/2);
		var borderBrush:SolidBrush = new SolidBrush(getColor(c));
		g.beginFill(borderBrush);
		g.rectangle(x+w/2+1, y+w/4+0.5, w, w);
		g.rectangle(x+w/2+0.5+1, y+w/4+1.5+0.5, w-1, w-2);
		g.endFill();
		g.beginFill(borderBrush);
		g.rectangle(x+w/4, y+w/2+1.5, w, w);
		g.rectangle(x+w/4+0.5, y+w/2+1.5+1.5, w-1, w-2);
		g.endFill();	
	}	
}
