package org.aswing.util;

import flash.utils.Dictionary;

/**
 * A map that both key and value are weaks.
 */
class WeakMap {
	
	
	
	var dic:Dictionary;
	
	public function new(){
		dic = new Dictionary(true);
	}
	
	public function put(key:Dynamic, value:Dynamic):Void{
		var wd:Dictionary = new Dictionary(true);
		wd[value] = null;
		dic[key] = wd;
	}
	
	public function getValue(key:Dynamic):Dynamic{
		var wd:Dictionary = dic[key];
		if(wd != null){
			for(v in Reflect.fields(wd)){
				return v;
			}
		}
		return null;
	}
	
	public function remove(key:Dynamic):Dynamic{
		var value:Dynamic = getValue(key);
		dic[key] = null;
		return value;
	}
}
