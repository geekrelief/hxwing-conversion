package org.aswing.util;

import flash.utils.Dictionary;
	
/**
 * WeakReference, the value will be weak referenced.
 * @author iiley
 */
class WeakReference {
	
	
	
	public var value(getValue, setValue) : Dynamic;
	
	var weakDic:Dictionary;
	
	public function new(){
		super();
	}
	
	public function setValue(v:Dynamic):Dynamic{
		if(v == null){
			weakDic = null;
		}else{
			weakDic = new Dictionary(true);
			weakDic[v] = null;
		}
		return v;
	}
	
	public function getValue():Dynamic{
		if(weakDic){
			for(v in weakDic){
				return v;
			}
		}
		return null;
	}
	
	/**
	 * Clear the value, same to <code>WeakReference.value=null;</code>
	 */
	public function clear():Void{
		weakDic = null;
	}
}
