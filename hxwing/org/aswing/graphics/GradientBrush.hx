/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.graphics;

import org.aswing.graphics.IBrush;
import flash.display.Graphics;
import flash.geom.Matrix;
import flash.display.GradientType;

/**
 * GradientBrush encapsulate the fill paramters for flash.display.Graphics.beginGradientFill()
 * @see http://livedocs.macromedia.com/flex/2/langref/flash/display/Graphics.html#beginGradientFill()
 * @author iiley
 */
class GradientBrush implements IBrush {
	
	
	
	public static var LINEAR:GradientType = GradientType.LINEAR;
	public static var RADIAL:GradientType = GradientType.RADIAL;
	
	var fillType:GradientType;
	var colors:Array<Dynamic>;
	var alphas:Array<Dynamic>;
	var ratios:Array<Dynamic>;
	var matrix:Matrix;
	var spreadMethod:String;
	var interpolationMethod:String;
	var focalPointRatio:Float;
	
	/**
	 * Create a GradientBrush object<br>
	 * you can refer the explaination for the paramters from Adobe's doc
	 * to create a Matrix, you can use matrix.createGradientBox() from the matrix object itself
	 * 
	 * @see http://livedocs.macromedia.com/flex/2/langref/flash/display/Graphics.html#beginGradientFill()
	 * @see http://livedocs.macromedia.com/flex/2/langref/flash/geom/Matrix.html#createGradientBox()
	 */
	public function new(fillType:GradientType , colors:Array<Dynamic>, alphas:Array<Dynamic>, ratios:Array<Dynamic>, matrix:Matrix, 
					?spreadMethod:String = "pad", ?interpolationMethod:String = "rgb", ?focalPointRatio:Int = 0){
		this.fillType = fillType;
		this.colors = colors;
		this.alphas = alphas;
		this.ratios = ratios;
		this.matrix = matrix;
		this.spreadMethod = spreadMethod;
		this.interpolationMethod = interpolationMethod;
		this.focalPointRatio = focalPointRatio;
	}
	
	public function getFillType():GradientType{
		return fillType;
	}
	
	/**
	 * 
	 */
	public function setFillType(t:GradientType):Void{
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
	 * Pay attention that the value in the array should be between 0-1. if the value is greater than 1, 1 will be used, if the value is less than 0, 0 will be used
	 */
	public function setAlphas(alphas:Array<Dynamic>):Void{
		this.alphas = alphas;
	}
	
	public function getRatios():Array<Dynamic>{
		return ratios;
	}
	
	/**
	 * Ratios should be between 0-255, if the value is greater than 255, 255 will be used, if the value is less than 0, 0 will be used
	 */
	public function setRatios(ratios:Array<Dynamic>):Void{
		ratios = ratios;
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
	 * @inheritDoc 
	 */
	public function beginFill(target:Graphics):Void{
		target.beginGradientFill(fillType, colors, alphas, ratios, matrix, 
			spreadMethod, interpolationMethod, focalPointRatio);
	}
	
	/**
	 * @inheritDoc 
	 */
	public function endFill(target:Graphics):Void{
		target.endFill();
	}	
}

