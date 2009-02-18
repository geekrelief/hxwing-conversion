/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;
	
import org.aswing.plaf.BaseComponentUI;
import Import_org_aswing;
import Import_org_aswing_event;

/**
 * ToolBar basic ui imp.
 * @author iiley
 * @private
 */
class BasicToolBarUI extends BaseComponentUI {
	
	
	
	var bar:Container;
	
	public function new(){
		super();
	}
	
    function getPropertyPrefix():String {
        return "ToolBar.";
    }
    
	public override function installUI(c:Component):Void{
		bar = cast(c, Container);
		installDefaults();
		installComponents();
		installListeners();
	}
    
	public override function uninstallUI(c:Component):Void{
		bar = cast(c, Container);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
 	}
 	
 	function installDefaults():Void{
        var pp:String = getPropertyPrefix();
        
        LookAndFeel.installColorsAndFont(bar, pp);
        LookAndFeel.installBorderAndBFDecorators(bar, pp);
        LookAndFeel.installBasicProperties(bar, pp);
 	}
	
 	function uninstallDefaults():Void{
 		LookAndFeel.uninstallBorderAndBFDecorators(bar);
 	}
 	
 	function installComponents():Void{
 		for(i in 0...bar.getComponentCount()){
 			adaptChild(bar.getComponent(i));
 		}
 	}
	
 	function uninstallComponents():Void{
 		for(i in 0...bar.getComponentCount()){
 			unadaptChild(bar.getComponent(i));
 		}
 	}
 	
 	function installListeners():Void{
 		bar.addEventListener(ContainerEvent.COM_ADDED, __onComAdded);
 		bar.addEventListener(ContainerEvent.COM_REMOVED, __onComRemoved);
 	}
	
 	function uninstallListeners():Void{
 		bar.removeEventListener(ContainerEvent.COM_ADDED, __onComAdded);
 		bar.removeEventListener(ContainerEvent.COM_REMOVED, __onComRemoved);
 	}
 	
 	function adaptChild(c:Component):Void{
    	var btn:AbstractButton = cast( c, AbstractButton);
    	if(btn != null){
    		var bg:GroundDecorator = btn.getBackgroundDecorator();
    		if(bg != null){
    			var bgAdapter:ToolBarButtonBgAdapter = new ToolBarButtonBgAdapter(bg);
    			btn.setBackgroundDecorator(bgAdapter);
    		}
    		btn.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, __propertyChanged);
    	}
 	}
 	
 	function unadaptChild(c:Component):Void{
    	var btn:AbstractButton = cast( c, AbstractButton);
    	if(btn != null){
    		btn.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, __propertyChanged);
    		var bg:ToolBarButtonBgAdapter = cast( btn.getBackgroundDecorator(), ToolBarButtonBgAdapter);
    		if(bg != null){
    			btn.setBackgroundDecorator(bg.getOriginalBg());
    		}
    	}
 	}
    
    //------------------------------------------------
 	
 	function __propertyChanged(e:PropertyChangeEvent):Void{
 		if(e.getPropertyName() == "backgroundDecorator"){
 			var btn:AbstractButton = cast( e.target, AbstractButton);
 			//var oldG:GroundDecorator = e.getOldValue();
 			var newG:GroundDecorator = e.getNewValue();
 			if(!(Std.is( newG, ToolBarButtonBgAdapter))){
    			var bgAdapter:ToolBarButtonBgAdapter = new ToolBarButtonBgAdapter(newG);
    			btn.setBackgroundDecorator(bgAdapter);
 			}
 		}
 	}
 	
    function __onComAdded(e:ContainerEvent):Void{
    	adaptChild(e.getChild());
    }
    
    function __onComRemoved(e:ContainerEvent):Void{
    	unadaptChild(e.getChild());
    }
}

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//                 BG Decorator Adapter
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

import org.aswing.graphics.Graphics2D;
import org.aswing.GroundDecorator;
import org.aswing.geom.IntRectangle;
import org.aswing.Component;
import flash.display.DisplayObject;
import org.aswing.AbstractButton;
import org.aswing.plaf.UIResource;

/**
 * This background adapter will invisible the original background, and visible it 
 * only when button be rollover.
 * @author iiley
 */
class ToolBarButtonBgAdapter implements GroundDecorator, implements UIResource{
	
	var originalBg:GroundDecorator;

	public function new(originalBg:GroundDecorator){
		this.originalBg = originalBg;
	}
	
	public function getOriginalBg():GroundDecorator{
		return originalBg;
	}
	
	public function updateDecorator(c:Component, g:Graphics2D, bounds:IntRectangle):Void{
		if(originalBg == null){
			return;
		}
		var btn:AbstractButton = cast( c, AbstractButton);
		var needPaint:Bool = false;
		if(btn == null || btn.getModel().isArmed() || btn.isSelected() 
			|| (btn.getModel().isRollOver() && !btn.getModel().isPressed())){
			needPaint = true;
		}
		var dis:DisplayObject = getDisplay(c);
		if(dis != null) dis.visible = needPaint;
		if(needPaint){
			originalBg.updateDecorator(c, g, bounds);
		}
	}
	
	public function getDisplay(c:Component):DisplayObject{
		if(originalBg == null){
			return null;
		}
        #if debug
        throw "ToolBarButtonBgAdapter#getDisplay: conversion to haxe.. What should this return? c / null?" 
        #end
        return c; // what should this return??
    }
}
