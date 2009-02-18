/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import flash.display.InteractiveObject;
import flash.events.EventDispatcher;
import flash.events.KeyboardEvent;
import flash.ui.Keyboard;

import org.aswing.event.InteractiveEvent;
import org.aswing.util.ArrayUtils;
import org.aswing.util.ArrayList;
import org.aswing.util.WeakReference;
	
/**
 * Dispatched when the menu selection changed.
 * 
 * @eventType org.aswing.event.InteractiveEvent.SELECTION_CHANGED
 */
/*[Event(name="selectionChanged", type="org.aswing.event.InteractiveEvent")]*/

/**
 * A MenuSelectionManager owns the selection in menu hierarchy.
 * 
 * @author iiley
 */
class MenuSelectionManager extends EventDispatcher {
		 	
	
		 	
	static var instance:MenuSelectionManager;
	
	var selection:ArrayList;
	
	public function new(){
        super();
		selection = new ArrayList();
	}
	
	public static function defaultManager():MenuSelectionManager{
		if(instance == null){
			instance = new MenuSelectionManager();
		}
		return instance;
	}
	
	/**
	 * Replaces the default manager by yours.
	 */
	public static function setDefaultManager(m:MenuSelectionManager):Void{
		instance = m;
	}
	
	var lastTriggerRef:WeakReference ;
    /**
     * Changes the selection in the menu hierarchy.  The elements
     * in the array are sorted in order from the root menu
     * element to the currently selected menu element.
     * <p>
     * Note that this method is public but is used by the look and
     * feel engine and should not be called by client applications.
     * </p>
     * @param path  an array of <code>MenuElement</code> objects specifying
     *        the selected path.
     * @param programmatic indicate if this is a programmatic change.
     */
    public function setSelectedPath(trigger:InteractiveObject, path:Array<Dynamic>, programmatic:Bool):Void { //MenuElement[] 
        var i:Int;
        var c:Int;
        var currentSelectionCount:Int = selection.size();
        var firstDifference:Int = 0;
				
        if(path == null) {
            path = new Array();
        }

        for(i in 0...c) {
            if(i < currentSelectionCount && selection.get(i) == path[i]){
                firstDifference++;
            }else{
                break;
            }
        }

        i=currentSelectionCount-1 ;
           while (i>=firstDifference) {
            var me:MenuElement = cast(selection.get(i), MenuElement);
            selection.removeAt(i);
            me.menuSelectionChanged(false);
        	i--;
           }

        i = firstDifference; 
        c = path.length;
        while (i < c ) {
        	var tm:MenuElement = cast(path[i], MenuElement);
		    if (tm != null) {
				selection.append(tm);
				tm.menuSelectionChanged(true);
		    }
			i++;
        }
		if(firstDifference < path.length - 1 || currentSelectionCount != path.length){
			fireSelectionChanged(programmatic);
		}
		var lastTrigger:InteractiveObject = lastTriggerRef.value;
		if(selection.size() == 0){
			if(lastTrigger != null){
				lastTrigger.removeEventListener(KeyboardEvent.KEY_DOWN, __onMSMKeyDown);
				lastTriggerRef.clear();
			}
		}else{
			if(lastTrigger != trigger){
				if(lastTrigger != null){
					lastTrigger.removeEventListener(KeyboardEvent.KEY_DOWN, __onMSMKeyDown);
				}
				lastTrigger = trigger;
				if(trigger != null){
					trigger.addEventListener(KeyboardEvent.KEY_DOWN, __onMSMKeyDown, false, 0, true);
				}
				lastTriggerRef.value = trigger;
			}
		}
    }
    
	/**
	 * Adds a listener to listen the menu seletion change event.
	 * @param listener the listener
	 * @param priority the priority
	 * @param useWeakReference Determines whether the reference to the listener is strong or weak.
	 * @see org.aswing.event.InteractiveEvent#STATE_CHANGED
	 */	
	public function addSelectionListener(listener:Dynamic, ?priority:Int=0, ?useWeakReference:Bool=false):Void{
		addEventListener(InteractiveEvent.SELECTION_CHANGED, listener, false, priority);
	}	
	
	/**
	 * Removes a menu seletion change listener.
	 * @param listener the listener to be removed.
	 * @see org.aswing.event.InteractiveEvent#STATE_CHANGED
	 */	
	public function removeSelectionListener(listener:Dynamic):Void{
		removeEventListener(InteractiveEvent.SELECTION_CHANGED, listener);
	}
	
    /**
     * Returns the path to the currently selected menu item
     *
     * @return an array of MenuElement objects representing the selected path
     */
    public function getSelectedPath():Array<Dynamic> { //MenuElement[]
        return selection.toArray();
    }

    /**
     * Tell the menu selection to close and unselect all the menu components. Call this method
     * when a choice has been made.
     * @param programmatic indicate if this is a programmatic change.
     */
    public function clearSelectedPath(programmatic:Bool):Void {
        if (selection.size() > 0) {
            setSelectedPath(null, null, true);
        }
    }
    
    /** 
     * Return true if c is part of the currently used menu
     */
    public function isComponentPartOfCurrentMenu(c:Component):Bool {
        if(selection.size() > 0) {
            var me:MenuElement = cast(selection.get(0), MenuElement);
            return isComponentPartOfMenu(me, c);
        }else{
            return false;
        }
    }
    
    public function isNavigatingKey(code:UInt):Bool{
    	return isPageNavKey(code) || isItemNavKey(code);
    }
    public function isPageNavKey(code:UInt):Bool{
    	return isPrevPageKey(code) || isNextPageKey(code);
    }
    public function isItemNavKey(code:UInt):Bool{
    	return isPrevItemKey(code) || isNextItemKey(code);
    }
    public function isPrevPageKey(code:UInt):Bool{
    	return code == Keyboard.LEFT;
    }
    public function isPrevItemKey(code:UInt):Bool{
    	return code == Keyboard.UP;
    }
    public function isNextPageKey(code:UInt):Bool{
    	return code == Keyboard.RIGHT;
    }
    public function isNextItemKey(code:UInt):Bool{
    	return code == Keyboard.DOWN;
    }
    public function isEnterKey(code:UInt):Bool{
    	return code == Keyboard.ENTER;
    }
    public function isEscKey(code:UInt):Bool{
    	return code == Keyboard.TAB || code == Keyboard.ESCAPE;
    }
    
    public function nextSubElement(parent:MenuElement, sub:MenuElement):MenuElement{
    	return besideSubElement(parent, sub, 1);
    }
    
    public function prevSubElement(parent:MenuElement, sub:MenuElement):MenuElement{
    	return besideSubElement(parent, sub, -1);
    }
    
    function besideSubElement(parent:MenuElement, sub:MenuElement, dir:Int):MenuElement{
    	if(parent == null || sub == null){
    		return null;
    	}
    	var subs:Array<Dynamic> = parent.getSubElements();
    	var index:Int = ArrayUtils.indexInArray(subs, sub);
    	if(index < 0){
    		return null;
    	}
    	index += dir;
    	if(index >= subs.length){
    		index = 0;
    	}else if(index < 0){
    		index = subs.length - 1;
    	}
    	return cast(subs[index], MenuElement);
    }

    function isComponentPartOfMenu(root:MenuElement, c:Component):Bool {
        var children:Array<Dynamic>;
        var d:Int;
	
		if (root == null){
		    return false;
		}
	
        if(root.getMenuComponent() == c){
            return true;
        }else {
            children = root.getSubElements();
            d = children.length;
            for(i in 0...d) {
            	var me:MenuElement = cast(children[i], MenuElement);
                if(me != null && isComponentPartOfMenu(me, c)){
                    return true;
                }
            }
        }
        return false;
	}
	
	function fireSelectionChanged(programmatic:Bool):Void{
		dispatchEvent(new InteractiveEvent(InteractiveEvent.SELECTION_CHANGED, programmatic));
	}
	
	function __onMSMKeyDown(e:KeyboardEvent):Void{
		if(selection.size() == 0){
			return;
		}
		var code:UInt = e.keyCode;
		if(isEscKey(code)){
			setSelectedPath(null, null, true);
			return;
		}
		var element:MenuElement = cast(selection.last(), MenuElement);
		element.processKeyEvent(code);
	}
	
}
