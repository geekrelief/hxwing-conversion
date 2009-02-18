/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;

import flash.display.DisplayObjectContainer;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.geom.Rectangle;
import flash.utils.Timer;

import Import_org_aswing;
import Import_org_aswing_event;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;
import Import_org_aswing_plaf_basic_frame;
import org.aswing.resizer.Resizer;

/**
 * Basic frame ui imp.
 * @author iiley
 * @private
 */
class BasicFrameUI extends BaseComponentUI, implements FrameUI {
	
	
	
	var frame:JFrame;
	var titleBar:FrameTitleBar;
	
	var resizeArrowColor:ASColor;
	var resizeArrowLightColor:ASColor;
	var resizeArrowDarkColor:ASColor;
	
	var mouseMoveListener:Dynamic;
	var boundsMC:Sprite;
	var flashTimer:Timer;
	
	public function new() {
		super();
	}

    public override function installUI(c:Component):Void {
        frame = cast(c, JFrame);
        installDefaults();
		installComponents();
		installListeners();
    }
    
	function getPropertyPrefix():String {
		return "Frame.";
	}
	
    function installDefaults():Void {
    	var pp:String = getPropertyPrefix();
		LookAndFeel.installColorsAndFont(frame, pp);
		LookAndFeel.installBorderAndBFDecorators(frame, pp);
		LookAndFeel.installBasicProperties(frame, pp);
		
	    resizeArrowColor = getColor("resizeArrow");
	    resizeArrowLightColor = getColor("resizeArrowLight");
	    resizeArrowDarkColor = getColor("resizeArrowDark");
	    var ico:Icon = frame.getIcon();
	    if(Std.is( ico, UIResource)){
	    	frame.setIcon(getIcon(getPropertyPrefix()+"icon"));
	    }
    }
    
    function installComponents():Void {
    	if(frame.getResizer() == null || Std.is( frame.getResizer(), UIResource)){
	    	var resizer:Resizer = cast( getInstance(getPropertyPrefix()+"resizer"), Resizer);
	    	frame.setResizer(resizer);
    	}
    	if(!frame.isDragDirectlySet()){
    		frame.setDragDirectly(getBoolean(getPropertyPrefix()+"dragDirectly"));
    		frame.setDragDirectlySet(false);
    	}
    	boundsMC = new Sprite();
    	boundsMC.name = "drag_bounds";
	}
	
	function installListeners():Void{
		frame.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, __titleBarChanged);
		frame.addEventListener(WindowEvent.WINDOW_ACTIVATED, __activeChange);
		frame.addEventListener(WindowEvent.WINDOW_DEACTIVATED, __activeChange);
		frame.addEventListener(PopupEvent.POPUP_CLOSED, __frameClosed);
		frame.addEventListener(Event.REMOVED_FROM_STAGE, __frameClosed);
		__titleBarChanged(null);
	}

    public override function uninstallUI(c:Component):Void {
        uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
    }
    
    function uninstallDefaults():Void {
		LookAndFeel.uninstallBorderAndBFDecorators(frame);
		frame.filters = [];
    }
    
	function uninstallComponents():Void{
		removeBoundsMC();
	}
	
	function uninstallListeners():Void{
		frame.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE, __titleBarChanged);
		frame.removeEventListener(WindowEvent.WINDOW_ACTIVATED, __activeChange);
		frame.removeEventListener(WindowEvent.WINDOW_DEACTIVATED, __activeChange);
		frame.removeEventListener(PopupEvent.POPUP_CLOSED, __frameClosed);
		frame.removeEventListener(Event.REMOVED_FROM_STAGE, __frameClosed);
		removeTitleBarListeners();
		if(flashTimer != null){
			flashTimer.stop();
			flashTimer = null;
		}
	}
	
	var flashing:Bool;
	var flashingActivedColor:Bool;

	/**
	 * Flash the modal frame. (User clicked other where is not in the modal frame, 
	 * flash the frame to make notice this frame is modal.)
	 */
	public function flashModalFrame():Void{
		if(flashTimer == null){
			flashTimer = new Timer(50, 8);
			flashTimer.addEventListener(TimerEvent.TIMER, __flashTick);
			flashTimer.addEventListener(TimerEvent.TIMER_COMPLETE, __flashComplete);
		}
		flashing = true;
		flashingActivedColor = false;
		flashTimer.reset();
		flashTimer.start();
	}
	
	function __flashTick(e:TimerEvent):Void{
		flashingActivedColor = !flashingActivedColor;
		frame.repaint();
		titleBar.getSelf().repaint();
	}
    
	function __flashComplete(e:TimerEvent):Void{
		flashing = false;
		frame.repaint();
		titleBar.getSelf().repaint();
	}

	/**
	 * For <code>flashModalFrame</code> to judge whether paint actived color or inactived color.
	 */    
	public function isPaintActivedFrame():Bool{
		if(flashing){
			return flashingActivedColor;
		}else{
			return frame.isActive();
		}
	}
    //----------------------------------------------------------
    override function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):Void{
    	var bgMargin:Insets = c.getUI().getInsets(getPropertyPrefix()+"backgroundMargin");
    	if(bgMargin != null){
    		b = bgMargin.getInsideBounds(b);
    	}
    	super.paintBackGround(c, g, b);
    }
    
    //----------------------------------------------------------
	
	function __titleBarChanged(e:PropertyChangeEvent):Void{
		if(e != null && e.getPropertyName() != JFrame.PROPERTY_TITLE_BAR){
			return;
		}
		var oldTC:Component;
		if(e  != null && e.getOldValue() != null){
			var oldT:FrameTitleBar = e.getOldValue();
			oldTC = oldT.getSelf();
		}
		if(oldTC != null){
			oldTC.removeEventListener(MouseEvent.MOUSE_DOWN, __onTitleBarPress);
			oldTC.removeEventListener(ReleaseEvent.RELEASE, __onTitleBarRelease);
			oldTC.removeEventListener(MouseEvent.DOUBLE_CLICK, __onTitleBarDoubleClick);
			oldTC.doubleClickEnabled = false;
		}
		titleBar = frame.getTitleBar();
		addTitleBarListeners();
	}
	
	function addTitleBarListeners():Void{
		if(titleBar != null){
			var titleBarC:Component = titleBar.getSelf();
			titleBarC.addEventListener(MouseEvent.MOUSE_DOWN, __onTitleBarPress);
			titleBarC.addEventListener(ReleaseEvent.RELEASE, __onTitleBarRelease);
			titleBarC.doubleClickEnabled = true;
			titleBarC.addEventListener(MouseEvent.DOUBLE_CLICK, __onTitleBarDoubleClick);
		}
	}
	
	function removeTitleBarListeners():Void{
		if(titleBar != null){
			var titleBarC:Component = titleBar.getSelf();
			titleBarC.removeEventListener(MouseEvent.MOUSE_DOWN, __onTitleBarPress);
			titleBarC.removeEventListener(ReleaseEvent.RELEASE, __onTitleBarRelease);
			titleBarC.doubleClickEnabled = false;
			titleBarC.removeEventListener(MouseEvent.DOUBLE_CLICK, __onTitleBarDoubleClick);
		}
	} 
	
	function isMaximizedFrame():Bool{
		var state:Int = frame.getState();
		return ((state & JFrame.MAXIMIZED_HORIZ) == JFrame.MAXIMIZED_HORIZ)
				|| ((state & JFrame.MAXIMIZED_VERT) == JFrame.MAXIMIZED_VERT);
	}
	
	function __activeChange(e:Event):Void{
		frame.repaint();
	}
	
	var startPos:IntPoint;
	var startMousePos:IntPoint;
    function __onTitleBarPress(e:MouseEvent):Void{
    	if(e.target != cast(titleBar, DisplayObject) && e.target != cast(titleBar.getLabel(), DisplayObject)){
    		return;
    	}
    	if(!titleBar.isTitleEnabled()){
    		return;
    	}
    	if(frame.isDragable() && !isMaximizedFrame()){
    		if(frame.isDragDirectly()){
    			var db:Rectangle = frame.getInsets().getInsideBounds(frame.getMaximizedBounds()).toRectangle();
    			var gap:Int = titleBar.getSelf().getHeight();
    			db.x -= (frame.width - gap);
    			db.y -= frame.getInsets().top;
    			db.width += (frame.width - gap*2);
    			db.height -= gap;
    			
    			frame.startDrag(false, db);
    		}else{
    			startMousePos = frame.getMousePosition();
    			startPos = frame.getLocation();
    			if(frame.stage != null){
    				frame.stage.addEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove, false, 0, true);
    			}
    		}
    	}
    }
    
    function __onTitleBarRelease(e:ReleaseEvent):Void{
    	if(e.getPressTarget() != cast(titleBar, DisplayObject) && e.getPressTarget() != cast(titleBar.getLabel(), DisplayObject)){
    		return;
    	}
    	if(!titleBar.isTitleEnabled()){
    		return;
    	}
    	frame.stopDrag();
    	if(frame.stage != null){
    		frame.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
    	}
    	if(frame.isDragable() && !isMaximizedFrame() && !frame.isDragDirectly()){
	    	var dest:IntPoint = representMoveBounds();
	    	frame.setLocation(dest);
	    	frame.validate();
    	}
    	removeBoundsMC();
    }
    
    function __onTitleBarDoubleClick(e:Event):Void{
    	if(e.target != cast(titleBar, DisplayObject) && e.target != cast(titleBar.getLabel(), DisplayObject)){
    		return;
    	}
    	if(!titleBar.isTitleEnabled()){
    		return;
    	}
		if(frame.isResizable()){
			var state:Int = frame.getState();
			
			if((state & JFrame.MAXIMIZED_HORIZ) == JFrame.MAXIMIZED_HORIZ
				|| (state & JFrame.MAXIMIZED_VERT) == JFrame.MAXIMIZED_VERT
				|| (state & JFrame.ICONIFIED) == JFrame.ICONIFIED){
					frame.setState(JFrame.NORMAL, false);
			}else{
				frame.setState(JFrame.MAXIMIZED, false);
			}
		}
    }
    
    function __frameClosed(e:Event):Void{
    	removeBoundsMC();
    	if(flashTimer != null){
    		flashTimer.stop();
    		flashTimer = null;
    	}
    	if(frame.stage != null){
    		frame.stage.removeEventListener(MouseEvent.MOUSE_MOVE, __onMouseMove);
    	}
    }
    
    function removeBoundsMC():Void{
    	if(frame.parent != null && frame.parent.contains(boundsMC)){
    		frame.parent.removeChild(boundsMC);
    	}
    }
    
    function representMoveBounds(?e:MouseEvent=null):IntPoint{
    	var par:DisplayObjectContainer = frame.parent;
    	if(boundsMC.parent != par){
    		par.addChild(boundsMC);
    	}
    	var currentMousePos:IntPoint = frame.getMousePosition();
    	var bounds:IntRectangle = frame.getComBounds();
    	bounds.x = startPos.x + currentMousePos.x - startMousePos.x;
    	bounds.y = startPos.y + currentMousePos.y - startMousePos.y;
    	
    	//these make user can't drag frames out the stage
    	var gap:Int = titleBar.getSelf().getHeight();
    	var frameMaxBounds:IntRectangle = frame.getMaximizedBounds();
    	
    	var topLeft:IntPoint = frameMaxBounds.leftTop();
    	var topRight:IntPoint = frameMaxBounds.rightTop();
    	var bottomLeft:IntPoint = frameMaxBounds.leftBottom();
    	if(bounds.x < topLeft.x - bounds.width + gap){
    		bounds.x = topLeft.x - bounds.width + gap;
    	}
    	if(bounds.x > topRight.x - gap){
    		bounds.x = topRight.x - gap;
    	}
    	if(bounds.y < topLeft.y){
    		bounds.y = topLeft.y;
    	}
    	if(bounds.y > bottomLeft.y - gap){
    		bounds.y = bottomLeft.y - gap;
    	}
    	
		var x:Int = bounds.x;
		var y:Int = bounds.y;
		var w:Int = bounds.width;
		var h:Int = bounds.height;
		var g:Graphics2D = new Graphics2D(boundsMC.graphics);
		boundsMC.graphics.clear();
		g.drawRectangle(new Pen(resizeArrowLightColor, 1), x-1,y-1,w+2,h+2);
		g.drawRectangle(new Pen(resizeArrowColor, 1), x,y,w,h);
		g.drawRectangle(new Pen(resizeArrowDarkColor, 1), x+1,y+1,w-2,h-2);
		return bounds.leftTop();
    }
    function __onMouseMove(e:MouseEvent):Void{
    	representMoveBounds(e);
    }
}
