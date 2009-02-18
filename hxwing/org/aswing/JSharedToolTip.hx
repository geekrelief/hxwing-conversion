/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;

import flash.utils.Dictionary;
import flash.display.InteractiveObject;	
	
/**
 * Shared instance Tooltip to saving instances.
 * @author iiley
 */
class JSharedToolTip extends JToolTip {
	
	
	
	static var sharedInstance:JSharedToolTip;
	
	var targetedComponent:InteractiveObject;
	var textMap:Dictionary;
	
	public function new() {
		super();
		setName("JSharedToolTip");
		textMap = new Dictionary(true);
	}
	
	/**
	 * Returns the shared JSharedToolTip instance.
	 * <p>
	 * You can create a your shared tool tip instance too, if you want to 
	 * shared by the default.
	 * </p>
	 * @return a singlton shared instance.
	 */
	public static function getSharedInstance():JSharedToolTip{
		if(sharedInstance == null){
			sharedInstance = new JSharedToolTip();
		}
		return sharedInstance;
	}
	
    /**
     * Registers a component for tooltip management.
     *
     * @param c  a <code>InteractiveObject</code> object to add.
     * @param (optional)tipText the text to show when tool tip display. If the c 
     * 		is a <code>Component</code> this param is useless, if the c is only a 
     * 		<code>InteractiveObject</code> this param is required.
     */
	public function registerComponent(c:InteractiveObject, ?tipText:String=null):Void{
		//TODO chech whether the week works
		listenOwner(c, true);
		untyped textMap[c] = tipText;
		if(getTargetComponent() == c){
			setTipText(getTargetToolTipText(c));
		}
	}
	

    /**
     * Removes a component from tooltip control.
     *
     * @param component  a <code>InteractiveObject</code> object to remove
     */
	public function unregisterComponent(c:InteractiveObject):Void{
		unlistenOwner(c);
		untyped __delete__(textMap, c);
		if(getTargetComponent() == c){
			disposeToolTip();
			targetedComponent = null;
		}
	}
	
	/**
	 * Registers a component that the tooltip describes. 
	 * The component c may be null and will have no effect. 
	 * <p>
	 * This method is overrided just to call registerComponent of this class.
	 * @param the InteractiveObject being described
	 * @see #registerComponent()
	 */
	public override function setTargetComponent(c:InteractiveObject):Void{
		registerComponent(c);
	}
	
	/** 
	 * Returns the lastest targeted component. 
	 * @return the lastest targeted component. 
	 */
	public override function getTargetComponent():InteractiveObject{
		return targetedComponent;
	}
	
	function getTargetToolTipText(c:InteractiveObject):String{
		if(Std.is( c, Component)){
			var co:Component = cast( c, Component);
			return co.getToolTipText();
		}else{
			return untyped textMap[c];
		}
	}
	
	//-------------
	override function __compRollOver(source:InteractiveObject):Void{
		var tipText:String = getTargetToolTipText(source);
		if(tipText != null && isWaitThenPopupEnabled()){
			targetedComponent = source;
			setTipText(tipText);
			startWaitToPopup();
		}
	}
	
	override function __compRollOut(source:InteractiveObject):Void{
		if(source == targetedComponent && isWaitThenPopupEnabled()){
			disposeToolTip();
			targetedComponent = null;
		}
	}	
}
