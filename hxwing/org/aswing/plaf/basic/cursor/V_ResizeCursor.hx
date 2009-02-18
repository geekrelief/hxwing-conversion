/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic.cursor;

import flash.display.Shape;
import Import_org_aswing_graphics;
import org.aswing.UIManager;
import org.aswing.ASColor;

/**
 * @private
 */
class V_ResizeCursor extends Shape {
	
	
	
	var resizeArrowColor:ASColor;
	var resizeArrowLightColor:ASColor;
	var resizeArrowDarkColor:ASColor;
	
	public function new(){
		super();
		
	    resizeArrowColor = UIManager.getColor("Frame.resizeArrow");
	    resizeArrowLightColor = UIManager.getColor("Frame.resizeArrowLight");
	    resizeArrowDarkColor = UIManager.getColor("Frame.resizeArrowDark");

		var w:Int = 1; //arrowAxisHalfWidth
		var r:Int = 4;
		var arrowPoints:Array<Dynamic>;
		
		arrowPoints = [{y:-r*2, x:0}, {y:-r, x:-r}, {y:-r, x:-w},
						 {y:r, x:-w}, {y:r, x:-r}, {y:r*2, x:0},
						 {y:r, x:r}, {y:r, x:w}, {y:-r, x:w},
						 {y:-r, x:r}];
		var gdi:Graphics2D = new Graphics2D(graphics);
		gdi.drawPolygon(new Pen(resizeArrowColor.changeAlpha(0.4), 4), arrowPoints);
		gdi.fillPolygon(new SolidBrush(resizeArrowLightColor), arrowPoints);
		gdi.drawPolygon(new Pen(resizeArrowDarkColor, 1), arrowPoints);			
	}
}
