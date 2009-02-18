/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.icon;

import Import_org_aswing;
import Import_org_aswing_graphics;
import Import_org_aswing_geom;

/**
 * The icon for frame maximize.
 * @author iiley
 * @private
 */
class FrameMaximizeIcon extends FrameIcon {

	

	public function new(){
		super();
	}	

	public override function updateIconImp(c:Component, g:Graphics2D, x:Int, y:Int):Void
	{
		var w:Float = width/1.5;
		var borderBrush:SolidBrush = new SolidBrush(getColor(c));
		g.beginFill(borderBrush);
		g.rectangle(x+w/4, y+w/4, w, w);
		g.rectangle(x+w/4+1, y+w/4+2, w-2, w-3);
		g.endFill();	
	}	
}

