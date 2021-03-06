/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;


import flash.events.EventDispatcher;
import Import_org_aswing_event;

/**
 * The default implementation of a <code>Button</code> component's data model.
 */
class DefaultButtonModel extends EventDispatcher, implements ButtonModel {
	
	
	
	var group:ButtonGroup;
	var enabled:Bool;
	var rollOver:Bool;
	var armed:Bool;
	var pressed:Bool;
	var selected:Bool;
	
	public function new(){
		super();
		enabled = true;
		rollOver = false;
		armed = false;
		pressed = false;
		selected = false;
	}
	
	
	public function isArmed():Bool{
		return armed;
	}
	
	public function isRollOver():Bool{
		return rollOver;
	}
	
	public function isSelected():Bool{
		return selected;
	}
	
	public function isEnabled():Bool{
		return enabled;
	}
	
	public function isPressed():Bool{
		return pressed;
	}
	
	public function setEnabled(b:Bool):Void{
        if(isEnabled() == b) {
            return;
        }
            
        enabled = b;
        if (!b) {
            pressed = false;
            armed = false;
        }
            
        fireStateChanged();
	}
	
	public function setPressed(b:Bool):Void{
        if((isPressed() == b) || !isEnabled()) {
            return;
        }
        pressed = b;
        
        if(!isPressed() && isArmed()) {
        	fireActionEvent();
        }
		
        fireStateChanged();
	}
	
	public function setRollOver(b:Bool):Void{
        if((isRollOver() == b) || !isEnabled()) {
            return;
        }
        rollOver = b;
        fireStateChanged();
	}
	
	public function setArmed(b:Bool):Void{
        if((isArmed() == b) || !isEnabled()) {
            return;
        }
            
        armed = b;
            
        fireStateChanged();
	}
	
	public function setSelected(b:Bool):Void{
        if (isSelected() == b) {
            return;
        }

        selected = b;
        
        fireStateChanged();
        fireSelectionChanged();
	}
	
	public function setGroup(group:ButtonGroup):Void{
		this.group = group;
	}
	
    /**
     * Returns the group that this button belongs to.
     * Normally used with radio buttons, which are mutually
     * exclusive within their group.
     *
     * @return a <code>ButtonGroup</code> that this button belongs to
     */
    public function getGroup():ButtonGroup {
        return group;
    }	
	
	public function addActionListener(listener:Dynamic, ?priority:Int=0, ?useWeakReference:Bool=false):Void{
		addEventListener(AWEvent.ACT, listener, false, priority);
	}
	
	public function removeActionListener(listener:Dynamic):Void{
		removeEventListener(AWEvent.ACT, listener);
	}
	
	public function addSelectionListener(listener:Dynamic, ?priority:Int=0, ?useWeakReference:Bool=false):Void{
		addEventListener(InteractiveEvent.SELECTION_CHANGED, listener, false, priority);
	}
	
	public function removeSelectionListener(listener:Dynamic):Void{
		removeEventListener(InteractiveEvent.SELECTION_CHANGED, listener);
	}
	
	public function addStateListener(listener:Dynamic, ?priority:Int=0, ?useWeakReference:Bool=false):Void{
		addEventListener(InteractiveEvent.STATE_CHANGED, listener, false, priority);
	}
	
	public function removeStateListener(listener:Dynamic):Void{
		removeEventListener(InteractiveEvent.STATE_CHANGED, listener);
	}
	
	function fireActionEvent():Void{
		dispatchEvent(new AWEvent(AWEvent.ACT));
	}
	
	function fireStateChanged():Void{
		dispatchEvent(new InteractiveEvent(InteractiveEvent.STATE_CHANGED));
	}
	
	function fireSelectionChanged():Void{
		dispatchEvent(new InteractiveEvent(InteractiveEvent.SELECTION_CHANGED));
	}
}
