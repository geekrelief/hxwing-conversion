/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;

import Import_org_aswing;
import Import_org_aswing_event;
import org.aswing.plaf.BaseComponentUI;
import org.aswing.geom.IntPoint;
import flash.ui.Keyboard;
import flash.events.MouseEvent;

/**
 * @private
 */
class BasicViewportUI extends BaseComponentUI {
	
    static var INT_MAX:Int = (2<<30) - 1;
	
	var viewport:JViewport;
	
	public function new(){
		super();
	}
	
	public override function installUI(c:Component):Void {
		viewport = cast(c, JViewport);
		installDefaults();
		installListeners();
	}

	public override function uninstallUI(c:Component):Void {
		viewport = cast(c, JViewport);
		uninstallDefaults();
		uninstallListeners();
	}

    function getPropertyPrefix():String {
        return "Viewport.";
    }

	function installDefaults():Void {
		var pp:String = getPropertyPrefix();
		LookAndFeel.installColorsAndFont(viewport, pp);
		LookAndFeel.installBorderAndBFDecorators(viewport, pp);
		LookAndFeel.installBasicProperties(viewport, pp);
	}

	function uninstallDefaults():Void {
		LookAndFeel.uninstallBorderAndBFDecorators(viewport);
	}
	
	function installListeners():Void{
		viewport.addEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onKeyDown);
		viewport.addEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel);
	}
	
	function uninstallListeners():Void{
		viewport.removeEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onKeyDown);
		viewport.removeEventListener(MouseEvent.MOUSE_WHEEL, __onMouseWheel);
	}
	
	function __onMouseWheel(e:MouseEvent):Void{
		if(!(viewport.isEnabled() && viewport.isShowing())){
			return;
		}
    	var viewPos:IntPoint = viewport.getViewPosition();
    	if(e.shiftKey){
    		viewPos.x -= e.delta*viewport.getHorizontalUnitIncrement();
    	}else{
    		viewPos.y -= e.delta*viewport.getVerticalUnitIncrement();
    	}
    	viewport.setViewPosition(viewPos);
	}
	
	function __onKeyDown(e:FocusKeyEvent):Void{
		if(!(viewport.isEnabled() && viewport.isShowing())){
			return;
		}
    	var code:UInt = e.keyCode;
    	var viewpos:IntPoint = viewport.getViewPosition();
    	switch(code){
    		case Keyboard.UP:
    			viewpos.move(0, -viewport.getVerticalUnitIncrement());
    		case Keyboard.DOWN:
    			viewpos.move(0, viewport.getVerticalUnitIncrement());
    		case Keyboard.LEFT:
    			viewpos.move(-viewport.getHorizontalUnitIncrement(), 0);
    		case Keyboard.RIGHT:
    			viewpos.move(viewport.getHorizontalUnitIncrement(), 0);
    		case Keyboard.PAGE_UP:
    			if(e.shiftKey){
    				viewpos.move(-viewport.getHorizontalBlockIncrement(), 0);
    			}else{
    				viewpos.move(0, -viewport.getVerticalBlockIncrement());
    			}
    		case Keyboard.PAGE_DOWN:
    			if(e.shiftKey){
    				viewpos.move(viewport.getHorizontalBlockIncrement(), 0);
    			}else{
    				viewpos.move(0, viewport.getVerticalBlockIncrement());
    			}
    		case Keyboard.HOME:
    			viewpos.setLocationXY(0, 0);
    		case Keyboard.END:
    			viewpos.setLocationXY(INT_MAX, INT_MAX);
    		default:
    			return;
    	}
    	viewport.setViewPosition(viewpos);
	}
}
