package org.aswing;

import Import_org_aswing_graphics;
import org.aswing.geom.IntRectangle;
import flash.display.DisplayObject;
import Import_flash_geom;
import flash.display.Shape;
import flash.display.GradientType;

/**
 * A background decorator that paint a gradient color.
 * @author
 */
class GradientBackground implements GroundDecorator {
	
	
	
	var brush:GradientBrush;
	var direction:Float;
	var shape:Shape;
	
	public function new(fillType:GradientType , colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, ?direction:Int=0, 
					?spreadMethod:String = "pad", ?interpolationMethod:String = "rgb", ?focalPointRatio:Int = 0){
		this.brush = new GradientBrush(fillType, colors, alphas, ratios, new Matrix(), 
			spreadMethod, interpolationMethod, focalPointRatio);
		this.direction = direction;
		shape = new Shape();
	}
	
	public function updateDecorator(com:Component, g:Graphics2D, bounds:IntRectangle):Void{
		shape.graphics.clear();
		g = new Graphics2D(shape.graphics);
		var matrix:Matrix = new Matrix();
		matrix.createGradientBox(bounds.width, bounds.height, direction, bounds.x, bounds.y);    
		brush.setMatrix(matrix);
		g.fillRectangle(brush, bounds.x, bounds.y, bounds.width, bounds.height);
	}
	
	public function getDisplay(c:Component):DisplayObject{
		return shape;
	}
	
}
