/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.util;
	
//import flash.utils.getQualifiedClassName;
//import flash.system.ApplicationDomain;
import flash.display.DisplayObject;

class Reflection {
	
	public function new() { }
	
	
	public static function getClassName(o:Dynamic):String{
        var s = Type.getClassName(Type.getClass(o));
        return s.split(".")[-1];
    }
    /*
	public static function createDisplayObjectInstance(fullClassName:String, ?applicationDomain:ApplicationDomain=null):DisplayObject{
		return cast( createInstance(fullClassName, applicationDomain), DisplayObject);
	}
	
	public static function createInstance(fullClassName:String, ?applicationDomain:ApplicationDomain=null):Dynamic{
		var assetClass:Class = getClass(fullClassName, applicationDomain);
		if(assetClass != null){
			return new assetClass();
		}
		return null;		
	}
	
	public static function getClass(fullClassName:String, ?applicationDomain:ApplicationDomain=null):Class{
		if(applicationDomain == null){
			applicationDomain = ApplicationDomain.currentDomain;
		}
		var assetClass:Class = cast( applicationDomain.getDefinition(fullClassName), Class);
		return assetClass;		
	}
	
	public static function getFullClassName(o:Dynamic):String{
		return getQualifiedClassName(o);
	}
	
	public static function getClassName(o:Dynamic):String{
		var name:String = getFullClassName(o);
		var lastI:Int = name.lastIndexOf(".");
		if(lastI >= 0){
			name = name.substr(lastI+1);
		}
		return name;
	}
	
	public static function getPackageName(o:Dynamic):String{
		var name:String = getFullClassName(o);
		var lastI:Int = name.lastIndexOf(".");
		if(lastI >= 0){
			return name.substring(0, lastI);
		}else{
			return "";
		}
	}
    */
}

