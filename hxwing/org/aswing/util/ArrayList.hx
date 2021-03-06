/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.util;

/**
 * ArrayList, a List implemented based on Array
 * 
 * 
 * @author firdosh
 * @author iiley
 */
class ArrayList implements List {
	
	
	
	var _elements:Array<Dynamic>;
	public static var CASEINSENSITIVE:Int=1;
	public static var DESCENDING:Int=2;
	public static var UNIQUESORT:Int=4;
	public static var RETURNINDEXEDARRAY:Int=8;	
	public static var NUMERIC:Int=16;	
	
	public function new(){
		_elements=new Array();	
	}
	
	/**
	 * Call the operation by pass each element once.
	 * <p>
	 * for example:
	 * <pre>
	 * //hide all component in vector components
	 * components.each( 
	 *     function(c:Component){
	 *         c.setVisible(false);
	 *     });
	 * <pre>
	 * @param operation the operation function for each element
	 */
	public function each(operation:Dynamic):Void{
		for(i in 0..._elements.length){
			operation(_elements[i]);
		}
	}
	
	/**
	 * Call the operation by pass each element once without the specified element.
	 * <p>
	 * for example:
	 * <pre>
	 * //hide all component in list components without firstOne component
	 * var firstOne:Component = the first one;
	 * components.eachWithout( 
	 * 	   firstOne,
	 *     function(c:Component){
	 *         c.setVisible(false);
	 *     });
	 * <pre>
	 * @param obj the which will not be operated.
	 * @param operation the operation function for each element
	 */
	public function eachWithout(obj:Dynamic, operation:Dynamic):Void{
		for(i in 0..._elements.length){
			if(_elements[i] != obj){
				operation(_elements[i]);
			}
		}
	}	
	
	public function get(i:Int):Dynamic{
		return _elements[i];
	}
	
	public function elementAt(i:Int):Dynamic{
		return get(i);
	}
	
	/**
	 * Append the object to the ArrayList
	 * 
	 * @param obj the object to append
	 * @param index where to append, if omited, appedn to the last position.
	 */
	public function append(obj:Dynamic, ?index:Int=-1):Void{
		if(index == -1){
			_elements.push(obj);
		}else{
            _elements.insert(index, obj);
		}
	}
	
	public function appendAll(arr:Array<Dynamic>, ?index:Int=-1):Void{
		if(arr == null || arr.length <= 0){
			return;
		}
		if(index == -1 || index == _elements.length){			
			_elements = _elements.concat(arr);
		}else if(index == 0){
			_elements = arr.concat(_elements);
		}else{
			var right:Array<Dynamic> = _elements.splice(index);
			_elements = _elements.concat(arr);
			_elements = _elements.concat(right);
		}
	}
	
	public function replaceAt(index:Int, obj:Dynamic):Dynamic{
		if(index<0 || index>= size()){
			return null;
		}
		else{		
			var oldObj:Dynamic = _elements[index];
			_elements[index] = obj;		
			return oldObj;
		}
	}
	
	public function removeAt(index:Int):Dynamic{
		if(index<0 || index>= size()){
			return null;
		}
		else{		
			var obj:Dynamic = _elements[index];
			_elements.splice(index, 1);		
			return obj;
		}
	}
	public function remove(obj:Dynamic):Dynamic{
		var i:Int = indexOf(obj);
		if(i>=0){
			return removeAt(i);
		}else{
			return null;
		}
	}
	
	/**
	 * Removes from this List all of the elements whose index is between fromIndex, 
	 * inclusive and toIndex inclusive. Shifts any succeeding elements to the left (reduces their index). 
	 * This call shortens the ArrayList by (toIndex - fromIndex) elements. (If toIndex less than fromIndex, 
	 * this operation has no effect.) 
	 * @return the elements were removed from the vector
	 */
	public function removeRange(fromIndex:Int, toIndex:Int):Array<Dynamic>{
		fromIndex = Std.int(Math.max(0, fromIndex));
		toIndex = Std.int(Math.min(toIndex, _elements.length-1));
		if(fromIndex > toIndex){
			return [];
		}else{
			return _elements.splice(fromIndex, toIndex-fromIndex+1);
		}
	}
	
	public function indexOf(obj:Dynamic):Int{
		for(i in 0..._elements.length){
			if(_elements[i] == obj){
				return i;
			}
		}
		return -1;
	}
		
	public function appendList(list : List, ?index : Int =-1) : Void {
		appendAll(list.toArray(), index);
	}

	public function pop():Dynamic {
		if(size() > 0){
			return _elements.pop();
		}else{
			return null;
		}
	}

	public function shift():Dynamic {
		if(size() > 0){
			return _elements.shift();
		}else{
			return undefined;
		}
	}
	
	public function lastIndexOf(obj:Dynamic):Int{
		var i:Int = _elements.length-1;
		while (i>=0){
			if(_elements[i] == obj){
				return i;
			}
			i--;
		}
		return -1;
	}
	
	public function contains(obj:Dynamic):Bool{
		return indexOf(obj) >=0;
	}
	
	public function first():Dynamic{
		return _elements[0];
	}
	
	public function last():Dynamic{
		return _elements[_elements.length-1];
	}
	
	public function size():Int{
		return _elements.length;
	}
	
	public function setElementAt(index:Int, element:Dynamic):Void{
		replaceAt(index, element);
	}
	
	public function getSize():Int{
		return size();
	}
	
	public function clear():Void{
		if(!isEmpty()){
			_elements.splice(0, _elements.length);
			_elements=new Array();
		}
	}
	
	public function clone():ArrayList{
		var cloned:ArrayList=new ArrayList();
		for (i in 0..._elements.length){
			cloned.append(_elements[i]);
		}		
		return cloned;
	}
	
	public function isEmpty():Bool{
		if(_elements.length>0)
			return false;
		else
			return true;
	}
	
	public function toArray():Array<Dynamic>{
		return _elements.concat([]);
	}
	
	/**
	 * Returns a array that contains elements start with startIndex and has length elements.
	 * @param startIndex the element started index(include)
	 * @param length length of the elements, if there is not enough elements left, return the elements ended to the end of the vector.
	 */
	public function subArray(startIndex:Int, length:Int):Array<Dynamic>{
		return _elements.slice(startIndex, Math.min(startIndex+length, size()));
	}
	
	public function sort(compare:Dynamic, options:Int):Array<Dynamic>{
		return _elements.sort(compare, options);
	}
	
	public function sortOn(key:Dynamic, options:Int):Array<Dynamic>{
		return _elements.sortOn(key, options);
	}
	
	public function toString():String{
		return "ArrayList : " + _elements.toString();
	}
	
}
