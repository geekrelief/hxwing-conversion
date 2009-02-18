/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.event;

/**
 * The base class for model events.
 * @author iiley
 */
class ModelEvent {
	
	
	
	var source:Dynamic;
	
	public function new(source:Dynamic){
		this.source = source;
	}
	
	public function getSource():Dynamic{
		return source;
	}
}
