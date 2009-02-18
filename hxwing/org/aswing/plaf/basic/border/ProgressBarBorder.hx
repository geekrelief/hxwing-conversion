/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.border;

	
import Import_org_aswing;
import Import_org_aswing_border;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;

/**
 * @private
 */
class ProgressBarBorder extends LineBorder, implements org.aswing.plaf.UIResource {
	
	public function new(){
		super();
	}
	
	public override function updateBorderImp(c:Component, g:Graphics2D, b:IntRectangle):Void
	{
		if(color == null){
			color = c.getUI().getColor("ProgressBar.foreground");
			setColor(color);
		}
		super.updateBorderImp(c, g, b);
	}
}
