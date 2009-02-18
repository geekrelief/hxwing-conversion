/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import flash.text.AntiAliasType;
import flash.text.GridFitType;
import flash.text.TextField;
	

/**
 * The advanced properties for font.
 * @see flash.text.TextField
 * @see flash.text.AntiAliasType
 * @see flash.text.GridFitType
 * @author iiley
 */
class ASFontAdvProperties {
	
	
 	
	
	
 	var antiAliasType:AntiAliasType;
 	var gridFitType:GridFitType;
 	var sharpness:Float;
 	var thickness:Float;
 	var embedFonts:Bool;
 	
	public function new(
		?embedFonts:Bool=false, ?antiAliasType:AntiAliasType,
		?gridFitType:GridFitType, ?sharpness:Int=0, ?thickness:Int=0){
		this.embedFonts = embedFonts;

        if(antiAliasType == null){
            antiAliasType = AntiAliasType.NORMAL;
        }
		this.antiAliasType = antiAliasType;

        if(gridFitType == null){
            gridFitType = GridFitType.PIXEL;
        }
		this.gridFitType = gridFitType;
		this.sharpness = sharpness;
		this.thickness = thickness;
	}
	
	public function getAntiAliasType():AntiAliasType{
		return antiAliasType;
	}
	
	public function changeAntiAliasType(newType:AntiAliasType):ASFontAdvProperties{
		return new ASFontAdvProperties(embedFonts, newType, gridFitType, sharpness, thickness);
	}
	
	public function getGridFitType():GridFitType{
		return gridFitType;
	}
	
	public function changeGridFitType(newType:GridFitType):ASFontAdvProperties{
		return new ASFontAdvProperties(embedFonts, antiAliasType, newType, sharpness, thickness);
	}
	
	public function getSharpness():Float{
		return sharpness;
	}
	
	public function changeSharpness(newSharpness:Float):ASFontAdvProperties{
		return new ASFontAdvProperties(embedFonts, antiAliasType, gridFitType, newSharpness, thickness);
	}
	
	public function getThickness():Float{
		return thickness;
	}
	
	public function changeThickness(newThickness:Float):ASFontAdvProperties{
		return new ASFontAdvProperties(embedFonts, antiAliasType, gridFitType, sharpness, newThickness);
	}
	
	public function isEmbedFonts():Bool{
		return embedFonts;
	}
	
	public function changeEmbedFonts(ef:Bool):ASFontAdvProperties{
		return new ASFontAdvProperties(ef, antiAliasType, gridFitType, sharpness, thickness);
	}	
	
	/**
	 * Applys the properties to the specified text field.
	 * @param textField the text filed to be applied font.
	 */
	public function apply(textField:TextField):Void{
		textField.embedFonts = isEmbedFonts();
		textField.antiAliasType = getAntiAliasType();
		textField.gridFitType = getGridFitType();
		textField.sharpness = getSharpness();
		textField.thickness = getThickness();
	}
	
	public function toString():String{
		return "ASFontAdvProperties[" 
			+ "embedFonts : " + embedFonts 
			+ ", antiAliasType : " + antiAliasType 
			+ ", gridFitType : " + gridFitType 
			+ ", sharpness : " + sharpness 
			+ ", thickness : " + thickness 
			+ "]";
	}
}
