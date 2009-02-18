/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.resizer;
	
import flash.events.Event;
import flash.events.MouseEvent;

import org.aswing.AWSprite;
import Import_org_aswing_event;
	
/**
 * The Handler for Resizer's mc bars.
 * @author iiley
 */
class DefaultResizeBarHandler {
	
	
	
	var resizer:DefaultResizer;
	var mc:AWSprite;
	var arrowRotation:Float;
	var strategy:ResizeStrategy;
	
	public function new(resizer:DefaultResizer, barMC:AWSprite, arrowRotation:Float, strategy:ResizeStrategy){
		this.resizer = resizer;
		mc = barMC;
		this.arrowRotation = arrowRotation;
		this.strategy = strategy;
		handle();
	}
	
	public static function createHandler(resizer:DefaultResizer, barMC:AWSprite, arrowRotation:Float, strategy:ResizeStrategy):DefaultResizeBarHandler{
		return new DefaultResizeBarHandler(resizer, barMC, arrowRotation, strategy);
	}
	
	function handle():Void{
		mc.addEventListener(MouseEvent.ROLL_OVER, __onRollOver);
		mc.addEventListener(MouseEvent.ROLL_OUT, __onRollOut);
		mc.addEventListener(MouseEvent.MOUSE_DOWN, __onPress);
		mc.addEventListener(MouseEvent.MOUSE_UP, __onUp);
		mc.addEventListener(MouseEvent.CLICK, __onRelease);
		mc.addEventListener(ReleaseEvent.RELEASE_OUT_SIDE, __onReleaseOutside);
		mc.addEventListener(Event.REMOVED_FROM_STAGE, __onDestroy);
	}
	
	function __onRollOver(e:MouseEvent):Void{
		if(!resizer.isResizing() && (e ==null || !e.buttonDown)){
			resizer.startArrowCursor();
			__rotateArrow();
			if(mc.stage != null){
				mc.stage.addEventListener(MouseEvent.MOUSE_MOVE, __rotateArrow, false, 0, true);
			}
		}
	}
	
	function __onRollOut(e:MouseEvent):Void{
		if(!resizer.isResizing() && !e.buttonDown){
			if(mc.stage != null){
				mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __rotateArrow);
			}
			resizer.stopArrowCursor();
		}
	}
	
	function __onPress(e:MouseEvent):Void{
		resizer.setResizing(true);
		startResize(e);
		if(mc.stage != null){
			mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __rotateArrow);
			mc.stage.addEventListener(MouseEvent.MOUSE_MOVE, resizing, false, 0, true);
		}
	}
	
	function __onUp(e:MouseEvent):Void{
		__onRollOver(null);
	}
	
	function __onRelease(e:Event):Void{
		resizer.setResizing(false);
		resizer.stopArrowCursor();
		if(mc.stage != null){
			mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE, resizing);
		}
		finishResize();
	}
	
	function __onReleaseOutside(e:Event):Void{
		__onRelease(e);
	}
	
	function __onDestroy(e:Event):Void{
		mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE, resizing);
		mc.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __rotateArrow);
	}
	
	function __rotateArrow(?e:Event=null):Void{
		resizer.setArrowRotation(arrowRotation);
	}
	
	function startResize(e:MouseEvent):Void{
		resizer.startResize(strategy, e);
	}
	
	function resizing(e:MouseEvent):Void{
		resizer.resizing(strategy, e);
	}
	
	function finishResize():Void{
		resizer.finishResize(strategy);
	}
}
