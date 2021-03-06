/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.tree;

import org.aswing.util.HashMap;
	
/**
 * A hash map that accept TreePath key.
 * @author iiley
 */	
class TreePathMap {
	
	
	
	var map:HashMap;
	var keyMap:HashMap;
	
	public function new(){
		map = new HashMap();
		keyMap = new HashMap();
	}
	
 	public function size():Int{
  		return map.size();
 	}
 	
 	public function isEmpty():Bool{
  		return map.isEmpty();
 	}

 	public function keys():Array<Dynamic>{
  		return keyMap.values();
 	}
 	
 	/**
  	 * Returns an Array of the values in this HashMap.
  	 */
 	public function values():Array<Dynamic>{
  		return map.values();
 	}
 	
 	public function containsValue(value:Dynamic):Bool{
 		return map.containsValue(value);
 	}

 	public function containsKey(key:TreePath):Bool{
 		return map.containsKey(key.getLastPathComponent());
 	}

 	public function get(key:TreePath):Dynamic{
  		return map.getValue(key.getLastPathComponent());
 	}
 	
 	public function getValue(key:TreePath):Dynamic{
  		return map.getValue(key.getLastPathComponent());
 	}

 	public function put(key:TreePath, value:Dynamic):Dynamic{
 		keyMap.put(key.getLastPathComponent(), key);
  		return map.put(key.getLastPathComponent(), value);
 	}

 	public function remove(key:TreePath):Dynamic{
 		keyMap.remove(key.getLastPathComponent());
 		return map.remove(key.getLastPathComponent());
 	}

 	public function clear():Void{
 		keyMap.clear();
  		map.clear();
 	}

 	/**
 	 * Return a same copy of HashMap object
 	 */
 	public function clone():TreePathMap{
  		var temp:TreePathMap = new TreePathMap();
  		temp.map = map.clone();
  		temp.keyMap = keyMap.clone();
  		return temp;
 	}

 	public function toString():String{
  		return map.toString();
 	}
}
