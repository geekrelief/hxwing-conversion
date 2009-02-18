
package org.aswing.plaf.basic.background;

import Import_org_aswing_graphics;
import org.aswing.GroundDecorator;
import org.aswing.geom.IntRectangle;
import org.aswing.Component;
import flash.display.DisplayObject;
import org.aswing.plaf.UIResource;
import flash.geom.Matrix;

/**
 * @private
 */
class TextComponentBackBround implements GroundDecorator, implements UIResource {
	
	public function new() { }
	
	
	public function updateDecorator(c:Component, g:Graphics2D, r:IntRectangle):Void{
    	if(c.isOpaque() && c.isEnabled()){
			var x:Int = r.x;
			var y:Int = r.y;
			var w:Int = r.width;
			var h:Int = r.height;
			g.fillRectangle(new SolidBrush(c.getBackground()), x, y, w, h);
			
			var colors:Array<Dynamic> = [0xF7F7F7, c.getBackground().getRGB()];
			var alphas:Array<Dynamic> = [0.5, 0];
			var ratios:Array<Dynamic> = [0, 100];
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(w, h, (90/180)*Math.PI, x, y);     
		    var brush:GradientBrush = new GradientBrush(GradientBrush.LINEAR, colors, alphas, ratios, matrix);
		    g.fillRectangle(brush, x, y, w, h);
    	}
	}
	
	public function getDisplay(c:Component):DisplayObject
	{
		return null;
	}
	
}
