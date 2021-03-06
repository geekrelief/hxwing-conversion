/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing;


import flash.display.Stage;
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import org.aswing.util.HashSet;
/**
 * RepaintManager use to manager the component's painting.
 * 
 * <p>If you want to repaint a component, call its repaint method, the component will register itself
 * to RepaintManager, when this frame end, it will call its paintImmediately method to paint its.
 * So component's repaint method is fast. But it will not paint immediately, if you want to paint
 * it immediately, you should call paintImmediately method, but it is not fast.</p>
 * @author iiley
 */	
class RepaintManager {
	
	
	
	static var instance:RepaintManager;
	
	/**
	 * Although it's a set in fact, but it work more like a queue
	 * The component will not be added twice into the repaintQueue (one time a component do not need more than one painting)
	 */
	var repaintQueue:HashSet;
	/**
	 * similar to repaintQueue
	 */
	var validateQueue:HashSet;
	
	var timer:Timer;
	var renderring:Bool;
	var alwaysUseTimer:Bool;
	
	/**
	 * Singleton class, 
	 * Don't create instance directly, in stead you should call <code>getInstance()</code>.
	 */
	public function new(){
		if(instance != null){
			throw new Error("Singleton can't be create more than once!");
		}
		repaintQueue = new HashSet();
		validateQueue = new HashSet();
		renderring = false;
		alwaysUseTimer = false;
		timer = new Timer(19, 1);
		timer.addEventListener(TimerEvent.TIMER_COMPLETE, __timerRender);
	}
	
	/**
	 * Init the repaint manager, it will works better when it is inited.
	 * By default, it will be inited when a component is added to stage automatically.
	 */	
	/*internal function init(theStage:Stage):void{
		if(stage == null){
			stage = theStage;
			stage.addEventListener(Event.RENDER, __render);
		}
	}*/
	
	public static function getInstance():RepaintManager{
		if(instance == null){
			instance = new RepaintManager();
		}
		return instance;
	}
	
	/**
	 * Sets whether or not always use timer to trigger the repaint progress.
	 * By default it is false, means use stage Event.RENDER to trigger at most time.
	 * It is better smooth for the rendering for Event.RENDER way, but if you make AsWing 
	 * components works with Flex component, you should change to timer way.
	 * @param b true to make it always use timer, false not.
	 * @param delay the timer delay, by default it is 19 ms.
	 */
	public function setAlwaysUseTimer(b:Bool, ?delay:Int=19):Void{
		alwaysUseTimer = b;
		timer.delay = delay;
	}
		
	/**
	 * Regist A Component need to repaint.
	 * @see org.aswing.Component#repaint()
	 */
	public function addRepaintComponent(com:Component):Void{
		repaintQueue.add(com);
		renderLater(com);
	}
	
	/**
	 * Find the Component's validate root parent and regist it need to validate.
	 * @see org.aswing.Component#revalidate()
	 * @see org.aswing.Component#validate()
	 * @see org.aswing.Component#invalidate()
	 */	
	public function addInvalidComponent(com:Component):Void{
		var validateRoot:Component = getValidateRootComponent(com);
		if(validateRoot != null){
			validateQueue.add(validateRoot);
			renderLater(com);
		}
	}
	
	/**
	 * Regists it need to be validated.
	 * @see org.aswing.Component#validate()
	 */	
	public function addInvalidRootComponent(com:Component):Void{
		validateQueue.add(com);
		renderLater(com);
	}
		
	function renderLater(c:Component):Void{
		var st:Stage = c.stage;
		if(alwaysUseTimer || st == null || renderring){
			if(!timer.running){
				timer.reset();
				timer.start();
			}
		}else{
			st.addEventListener(Event.RENDER, __render, false, 0, true);
			st.invalidate();
		}
	}
	
	/**
	 * If the ancestor of the component has no parent or it is isValidateRoot 
	 * and it's parent are visible, then it will be the validate root component,
	 * else it has no validate root component.
	 */
	function getValidateRootComponent(com:Component):Component{
		var validateRoot:Component = null;
		var i:Component;
		i = com;
		while (i!=null){
			if(i.isValidateRoot()){
				validateRoot = i;
				break;
			}
			i=i.getParent();
		}
		
		//var root:Component = null;
		//TODO: check if the root here is needed, if not delte the var declar
		i = validateRoot;
		while (i!=null){
			if(!i.isVisible()){
				//return null;
			}
			i=i.getParent();
		}
		return validateRoot;
	}
	
	function __timerRender(e:TimerEvent):Void{
		__render();
		e.updateAfterEvent();
	}
	
	/**
	 * Every frame this method will be executed to invoke the painting of components needed.
	 */
	function __render(?e:Event=null):Void{
		if(e != null){
			var st:Stage = cast( e.currentTarget, Stage);
			st.removeEventListener(Event.RENDER, __render);
		}
		var i:Int;
		var n:Int;
		var com:Component;
		//time++;
		
		renderring = true;
		
//		var time:Number = getTimer();
		var processValidates:Array<Dynamic> = validateQueue.toArray();
		//must clear here, because there maybe addRepaintComponent at below operation
		validateQueue.clear();
		n = processValidates.length;
		i = -1;
		if(n > 0){
			//trace("------------------------one tick---------------------------");
		}
		while((++i) < n){
			com = processValidates[i];
			com.validate();
			//trace("validating com : " + com);
		}
//		if(n > 0){
//			trace(n + " validate time : " + (getTimer() - time));
//		}
//		time = getTimer();
		
		
		var processRepaints:Array<Dynamic> = repaintQueue.toArray();
		//must clear here, because there maybe addInvalidComponent at below operation
		repaintQueue.clear();
		
		n = processRepaints.length;
		i = -1;
		while((++i) < n){
			com = processRepaints[i];
			com.paintImmediately();
		}
//		if(n > 0){
//			trace(n + " paint time : " + (getTimer() - time));
//		}
		renderring = false;
	}	
}
