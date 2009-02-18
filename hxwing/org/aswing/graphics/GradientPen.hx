/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.graphics;
		
import flash.geom.Matrix;
import flash.display.Graphics;

/**
 * GradientPen to draw Gradient lines.
 * @see org.aswing.graphics.Graphics2D
 * @see org.aswing.graphics.IPen
 * @see org.aswing.graphics.Pen
 * @see http://livedocs.macromedia.com/flex/2/langref/flash/display/Graphics.html#lineGradientStyle()
 * @author n0rthwood
 */		
class GradientPen implements IPen {
	
	
	
	var thickness:UInt;
	var fillType:String;
	var colors:Array<Dynamic>;
	var alphas:Array<Dynamic>;
	var ratios:Array<Dynamic>;
	var matrix:Matrix;
	var spreadMethod:String;
	var interpolationMethod:String;
	var focalPointRatio:Float;

	public function new(thickness:UInt,fillType:String, colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, ?matrix:Matrix = null, ?spreadMethod:String = "pad", ?interpolationMethod:String = "rgb", ?focalPointRatio:Int = 0){
		this.thickness = thickness;
		this.fillType = fillType;
		this.colors = colors;
		this.alphas = alphas;
		this.ratios = ratios;
		this.matrix = matrix;
		this.spreadMethod = spreadMethod;
		this.interpolationMethod = interpolationMethod;
		this.focalPointRatio = focalPointRatio;
	}
	
	public function getSpreadMethod():String{
		return this.spreadMethod;
	}
	
	/**
	 * 
	 */
	public function setSpreadMethod(spreadMethod:String):Void{
		this.spreadMethod=spreadMethod;
	}
	
	public function getInterpolationMethod():String{
		return this.interpolationMethod;
	}
	
	/**
	 * 
	 */
	public function setInterpolationMethod(interpolationMethod:String):Void{
		this.interpolationMethod=interpolationMethod;
	}
	
	public function getFocalPointRatio():Float{
		return this.focalPointRatio;
	}
	
	/**
	 * 
	 */
	public function setFocalPointRatio(focalPointRatio:Float):Void{
		this.focalPointRatio=focalPointRatio;
	}
	
	public function getFillType():String{
		return fillType;
	}
	
	/**
	 * 
	 */
	public function setFillType(t:String):Void{
		fillType = t;
	}
		
	public function getColors():Array<Dynamic>{
		return colors;
	}
	
	/**
	 * 
	 */
	public function setColors(cs:Array<Dynamic>):Void{
		colors = cs;
	}
	
	public function getAlphas():Array<Dynamic>{
		return alphas;
	}
	
	/**
	 * 
	 */
	public function setAlphas(alphas:Array<Dynamic>):Void{
		this.alphas = alphas;
	}
	
	public function getRatios():Array<Dynamic>{
		return ratios;
	}
	
	/**
	 * 
	 */
	public function setRatios(rs:Array<Dynamic>):Void{
		ratios = rs;		
	}
	
	public function getMatrix():Dynamic{
		return matrix;
	}
	
	/**
	 * 
	 */
	public function setMatrix(m:Matrix):Void{
		matrix = m;
	}
	
	/**
	 * 
	 */
	public function setTo(target:Graphics):Void{
		target.lineGradientStyle(fillType,colors,alphas,ratios,matrix,spreadMethod,interpolationMethod,focalPointRatio);
	}
}

