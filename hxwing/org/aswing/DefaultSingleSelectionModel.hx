/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import flash.events.Event;
import flash.events.EventDispatcher;

import Import_org_aswing_event;
import Import_org_aswing_util;

/**
 * A generic implementation of SingleSelectionModel.
 * @author iiley
 */
class DefaultSingleSelectionModel extends EventDispatcher, implements SingleSelectionModel {
	
	
	
	var index:Int;
	
	public function new(){
        super();
		index = -1;
	}
	
	public function getSelectedIndex() : Int {
		return index;
	}

	public function setSelectedIndex(index : Int, ?programmatic:Bool=true) : Void {
		if(this.index != index){
			this.index = index;
			fireChangeEvent(programmatic);
		}
	}

	public function clearSelection(?programmatic:Bool=true) : Void {
		setSelectedIndex(-1, programmatic);
	}

	public function isSelected() : Bool {
		return getSelectedIndex() != -1;
	}
	
	public function addStateListener(listener:Dynamic, ?priority:Int=0, ?useWeakReference:Bool=false):Void{
		addEventListener(InteractiveEvent.STATE_CHANGED, listener, false,  priority, useWeakReference);
	}
	
	public function removeStateListener(listener:Dynamic):Void{
		removeEventListener(InteractiveEvent.STATE_CHANGED, listener);
	}
	
	function fireChangeEvent(programmatic:Bool):Void{
		dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED, programmatic));
	}
}
