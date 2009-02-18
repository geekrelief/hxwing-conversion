/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.dnd;

/**
 * The drag source data.
 * @author iiley
 */
class SourceData {
	
	
	
	var name:String;
	var data:Dynamic;
	
	public function new(name:String, data:Dynamic){
		this.name = name;
		this.data = data;
	}
	
	public function getName():String{
		return name;
	}
	
	public function getData():Dynamic{
		return data;
	}	
}
