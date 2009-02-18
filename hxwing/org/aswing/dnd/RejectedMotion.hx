/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.dnd;

import org.aswing.Component;
import flash.display.Sprite;
import flash.utils.Timer;
import flash.events.TimerEvent;
import flash.geom.Point;
import org.aswing.geom.IntPoint;

/**
 * The motion of the drop target does not accept the dropped initiator. 
 * @author iiley
 */
class RejectedMotion implements DropMotion {
		
	
		
	var timer:Timer;
	var initiatorPos:IntPoint;
	var dragObject:Sprite;
	
	public function new(){
		timer = new Timer(40);
		timer.addEventListener(TimerEvent.TIMER, __enterFrame);
	}
	
	function startNewMotion(dragInitiator:Component, dragObject : Sprite):Void{
		this.dragObject = dragObject;
		initiatorPos = dragInitiator.getGlobalLocation();
		if(initiatorPos == null){
			initiatorPos = new IntPoint();
		}
		timer.start();
	}
	
	public function forceStop():Void{
		finishMotion();
	}
	
	public function startMotionAndLaterRemove(dragInitiator:Component, dragObject : Sprite) : Void {
		startNewMotion(dragInitiator, dragObject);
	}
	
	function finishMotion():Void{
		if(timer.running){
			timer.stop();
			dragObject.alpha = 1;
			if(dragObject.parent != null){
				dragObject.parent.removeChild(dragObject);
			}
		}
	}
	
	function __enterFrame(e:TimerEvent):Void{
		//check first
		var speed:Float = 0.25;
		
		var p:Point = new Point(dragObject.x, dragObject.y);
		p = dragObject.parent.localToGlobal(p);
		p.x += (initiatorPos.x - p.x) * speed;
		p.y += (initiatorPos.y - p.y) * speed;
		if(Point.distance(p, initiatorPos.toPoint()) < 2){
			finishMotion();
			return;
		}
		p = dragObject.parent.globalToLocal(p);
		dragObject.alpha += (0.04 - dragObject.alpha) * speed;
		dragObject.x = p.x;
		dragObject.y = p.y;
	}
	
}
