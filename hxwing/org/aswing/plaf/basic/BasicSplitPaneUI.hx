package org.aswing.plaf.basic;
	
import flash.display.DisplayObject;
import flash.display.Shape;
import Import_flash_events;
import flash.geom.Point;

import Import_org_aswing;
import Import_org_aswing_event;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;
import Import_org_aswing_plaf_basic_splitpane;

/**
 * @private
 */
class BasicSplitPaneUI extends SplitPaneUI, implements org.aswing.LayoutManager {
	
	
	
	var sp:JSplitPane;
	var divider:Divider;
	var lastContentSize:IntDimension;
	var spLis:Dynamic;
	var mouseLis:Dynamic;
	var vSplitCursor:DisplayObject;
	var hSplitCursor:DisplayObject;
	var presentDragColor:ASColor;
	var defaultDividerSize:Int;
	
	var startDragPos:IntPoint;
	var startLocation:Int;
	var startDividerPos:IntPoint;
	var dragRepresentationMC:Shape;
	var pressFlag:Bool;  //the flag for pressed left or right collapseButton
	var mouseInDividerFlag:Bool;	

    static var INT_MAX:Int = (2<<30)-1;
	
	public function new() {
		super();
	}
	
    function getPropertyPrefix():String {
        return "SplitPane.";
    }
    
    public override function installUI(c:Component):Void {
        sp = cast(c, JSplitPane);
        installDefaults();
        installComponents();
        installListeners();
    }

    public override function uninstallUI(c:Component):Void {
        sp = cast(c, JSplitPane);
        uninstallDefaults();
        uninstallComponents();
        uninstallListeners();
    }
    
    function installDefaults():Void {
    	var pp:String = getPropertyPrefix();
        LookAndFeel.installColorsAndFont(sp, pp);
        LookAndFeel.installBorderAndBFDecorators(sp, pp);
        LookAndFeel.installBasicProperties(sp, pp);
        presentDragColor = getColor(pp+"presentDragColor");
        defaultDividerSize = getInt(pp+"defaultDividerSize");
        lastContentSize = new IntDimension();
        sp.setLayout(this);
    }

    function uninstallDefaults():Void {
        LookAndFeel.uninstallBorderAndBFDecorators(sp);
        sp.setDividerLocation(0, true);
    }
	
	function installComponents():Void{
		vSplitCursor = createSplitCursor(true);
		hSplitCursor = createSplitCursor(false);
		divider = createDivider();
		divider.setUIElement(true);
		sp.append(divider, JSplitPane.DIVIDER);
		
		divider.addEventListener(MouseEvent.MOUSE_DOWN, __div_pressed);
		divider.addEventListener(ReleaseEvent.RELEASE, __div_released);
		divider.addEventListener(MouseEvent.ROLL_OVER, __div_rollover);
		divider.addEventListener(MouseEvent.ROLL_OUT, __div_rollout);
		
		divider.getCollapseLeftButton().addEventListener(MouseEvent.ROLL_OVER, __div_rollout);
		divider.getCollapseRightButton().addEventListener(MouseEvent.ROLL_OVER, __div_rollout);
		divider.getCollapseLeftButton().addEventListener(MouseEvent.ROLL_OUT, __div_rollover);
		divider.getCollapseRightButton().addEventListener(MouseEvent.ROLL_OUT, __div_rollover);		
		divider.getCollapseLeftButton().addActionListener(__collapseLeft);
		divider.getCollapseRightButton().addActionListener(__collapseRight);
	}
	
	function uninstallComponents():Void{
		sp.remove(divider);
		divider.removeEventListener(MouseEvent.MOUSE_DOWN, __div_pressed);
		divider.removeEventListener(ReleaseEvent.RELEASE, __div_released);
		divider.removeEventListener(MouseEvent.ROLL_OVER, __div_rollover);
		divider.removeEventListener(MouseEvent.ROLL_OUT, __div_rollout);
		
		divider.getCollapseLeftButton().removeEventListener(MouseEvent.ROLL_OVER, __div_rollout);
		divider.getCollapseRightButton().removeEventListener(MouseEvent.ROLL_OVER, __div_rollout);
		divider.getCollapseLeftButton().removeEventListener(MouseEvent.ROLL_OUT, __div_rollover);
		divider.getCollapseRightButton().removeEventListener(MouseEvent.ROLL_OUT, __div_rollover);
		divider.getCollapseLeftButton().removeActionListener(__collapseLeft);
		divider.getCollapseRightButton().removeActionListener(__collapseRight);
		divider = null;
	}
	
	function installListeners():Void{
		sp.addEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __on_splitpane_key_down);
		sp.addEventListener(InteractiveEvent.STATE_CHANGED, __div_location_changed);
	}
	
	function uninstallListeners():Void{
		sp.removeEventListener(KeyboardEvent.KEY_DOWN, __on_splitpane_key_down);
		sp.removeEventListener(InteractiveEvent.STATE_CHANGED, __div_location_changed);
	}
	
	/**
	 * Override this method to return a different splitCursor for your UI<br>
	 * Credit to Kristof Neirynck for added this.
	 */
	function createSplitCursor(vertical:Bool):DisplayObject{
		var result:DisplayObject;
		if(vertical){
			result = Cursor.createCursor(Cursor.V_MOVE_CURSOR);
		}else{
			result = Cursor.createCursor(Cursor.H_MOVE_CURSOR);
		}
		return result;
	}
	
	/**
	 * Override this method to return a different divider for your UI
	 */
	function createDivider():Divider{
		return new Divider(sp);
	}
    
	/**
	 * Override this method to return a different default divider size for your UI
	 */
    function getDefaultDividerSize():Int{
    	return defaultDividerSize;
    }
    /**
	 * Override this method to return a different default DividerDragingRepresention for your UI
	 */
    function paintDividerDragingRepresention(g:Graphics2D):Void{
		g.fillRectangle(new SolidBrush(presentDragColor.changeAlpha(0.4)), 0, 0, 1, 1);
    }
	
    /**
     * Messaged to relayout the JSplitPane based on the preferred size
     * of the children components.
     */
    public override function resetToPreferredSizes(jc:JSplitPane):Void{
    	var loc:Int = jc.getDividerLocation();
    	if(isVertical()){
    		if(jc.getLeftComponent() == null){
    			loc = 0;
    		}else{
    			loc = jc.getLeftComponent().getPreferredHeight();
    		}
    	}else{
    		if(jc.getLeftComponent() == null){
    			loc = 0;
    		}else{
    			loc = jc.getLeftComponent().getPreferredWidth();
    		}
    	}
		loc = Std.int(Math.max( getMinimumDividerLocation(), Math.min(loc, getMaximumDividerLocation())));
		jc.setDividerLocation(loc);
    }
    
	public override function paint(c:Component, g:Graphics2D, b:IntRectangle):Void{
		super.paint(c, g, b);
		divider.paintImmediately();
	}    
    
    public function layoutWithLocation(location:Int):Void{
    	var rect:IntRectangle = sp.getSize().getBounds(0, 0);
    	rect = sp.getInsets().getInsideBounds(rect);
    	var lc:Component = sp.getLeftComponent();
    	var rc:Component = sp.getRightComponent();
    	var dvSize:Int = getDividerSize();
    	location = Math.floor(location);
    	if(location < 0){
    		//collapse left
			if(isVertical()){
				divider.setComBoundsXYWH(rect.x, rect.y, rect.width, dvSize);
				if(rc != null)
					rc.setComBoundsXYWH(rect.x, rect.y+dvSize, rect.width, rect.height-dvSize);
			}else{
				divider.setComBoundsXYWH(rect.x, rect.y, dvSize, rect.height);
				if(rc != null)
					rc.setComBoundsXYWH(rect.x+dvSize, rect.y, rect.width-dvSize, rect.height);
			}
			if(lc != null)
    			lc.setVisible(false);
    		if(rc != null)
    			rc.setVisible(true);
    	}else if(location == INT_MAX){
    		//collapse right
			if(isVertical()){
				divider.setComBoundsXYWH(
					rect.x, 
					rect.y+rect.height-dvSize, 
					rect.width, 
					dvSize);
				if(lc != null){
					lc.setComBoundsXYWH(
						rect.x, 
						rect.y,
						rect.width, 
						rect.height-dvSize);
				}
			}else{
				divider.setComBoundsXYWH(
					rect.x+rect.width-dvSize, 
					rect.y, 
					dvSize, 
					rect.height);
				if(lc != null){
					lc.setComBoundsXYWH(
						rect.x, 
						rect.y,
						rect.width-dvSize, 
						rect.height);
				}
			}
			if(lc != null)
    			lc.setVisible(true);
    		if(rc != null)
    			rc.setVisible(false);
    	}else{
    		//both visible
			if(isVertical()){
				divider.setComBoundsXYWH(
					rect.x, 
					rect.y+location, 
					rect.width, 
					dvSize);
				if(lc != null)
				lc.setComBoundsXYWH(
					rect.x, 
					rect.y,
					rect.width, 
					location);
				if(rc != null)
				rc.setComBoundsXYWH(
					rect.x, 
					rect.y+location+dvSize, 
					rect.width, 
					rect.height-location-dvSize
				);
			}else{
				divider.setComBoundsXYWH(
					rect.x+location, 
					rect.y, 
					dvSize, 
					rect.height);
				if(lc != null)
				lc.setComBoundsXYWH(
					rect.x, 
					rect.y,
					location, 
					rect.height);
				if(rc != null)
				rc.setComBoundsXYWH(
					rect.x+location+dvSize, 
					rect.y, 
					rect.width-location-dvSize, 
					rect.height
				);
			}
			if(lc != null)
    		lc.setVisible(true);
    		if(rc != null)
    		rc.setVisible(true);
    	}
    	if(lc != null)
    	lc.revalidateIfNecessary();
    	if(rc != null)
    	rc.revalidateIfNecessary();
    	divider.revalidateIfNecessary();
    }
    
    public function getMinimumDividerLocation():Int{
    	var leftCom:Component = sp.getLeftComponent();
    	if(leftCom == null){
    		return 0;
    	}else{
    		if(isVertical()){
    			return leftCom.getMinimumHeight();
    		}else{
    			return leftCom.getMinimumWidth();
    		}
    	}
    }
    
    public function getMaximumDividerLocation():Int{
    	var rightCom:Component = sp.getRightComponent();
    	var insets:Insets = sp.getInsets();
    	var rightComSize:Int = 0;
    	if(rightCom != null){
    		rightComSize = isVertical() ? rightCom.getMinimumHeight() : rightCom.getMinimumWidth();
    	}
		if(isVertical()){
			return sp.getHeight() - insets.top - insets.bottom - getDividerSize() - rightComSize;
		}else{
			return sp.getWidth() - insets.left - insets.right - getDividerSize() - rightComSize;
		}
    }
    
    function isVertical():Bool{
    	return sp.getOrientation() == JSplitPane.VERTICAL_SPLIT;
    }
    
    function getDividerSize():Int{
    	var si:Int = sp.getDividerSize();
    	if(si < 0){
    		return getDefaultDividerSize();
    	}else{
    		return si;
    	}
    }
    
    function restrictDividerLocation(loc:Int):Int{
    	return Std.int(Math.max( getMinimumDividerLocation(), Math.min(loc, getMaximumDividerLocation())));
    }
    //-----------------------------------------------------------------------
    
	function __collapseLeft(e:AWEvent) : Void {
		pressFlag = true;
		if(sp.getDividerLocation() == INT_MAX){
			sp.setDividerLocation(sp.getLastDividerLocation());
			divider.getCollapseLeftButton().setEnabled(true);
			divider.getCollapseRightButton().setEnabled(true);
		}else if(sp.getDividerLocation() >= 0){
			sp.setDividerLocation(-1);
			divider.getCollapseLeftButton().setEnabled(false);
		}else{
			divider.getCollapseLeftButton().setEnabled(true);
		}
	}

	function __collapseRight(e:AWEvent) : Void {
		pressFlag = true;		
		if(sp.getDividerLocation() < 0){
			sp.setDividerLocation(sp.getLastDividerLocation());
			divider.getCollapseRightButton().setEnabled(true);
			divider.getCollapseLeftButton().setEnabled(true);
		}else if(sp.getDividerLocation() != INT_MAX){
			sp.setDividerLocation(INT_MAX);
			divider.getCollapseRightButton().setEnabled(false);
		}else{
			divider.getCollapseRightButton().setEnabled(false);
		}
	}
	
	function __on_splitpane_key_down(e:FocusKeyEvent):Void{
		var code:UInt = e.keyCode;
		var dir:Int = 0;
		if(code == KeyStroke.VK_HOME.getCode()){
			if(sp.getDividerLocation() < 0){
				sp.setDividerLocation(sp.getLastDividerLocation());
			}else{
				sp.setDividerLocation(-1);
			}
			return;
		}else if(code == KeyStroke.VK_END.getCode()){
			if(sp.getDividerLocation() == INT_MAX){
				sp.setDividerLocation(sp.getLastDividerLocation());
			}else{
				sp.setDividerLocation(INT_MAX);
			}
			return;
		}
		if(code == KeyStroke.VK_LEFT.getCode() || code == KeyStroke.VK_UP.getCode()){
			dir = -1;
		}else if(code == KeyStroke.VK_RIGHT.getCode() || code == KeyStroke.VK_DOWN.getCode()){
			dir = 1;
		}
		if(e.shiftKey){
			dir *= 10;
		}
		sp.setDividerLocation(restrictDividerLocation(sp.getDividerLocation() + dir));
	}
    
    function __div_location_changed(e:InteractiveEvent):Void{
    	layoutWithLocation(sp.getDividerLocation());
        if(sp.getDividerLocation() >= 0 && sp.getDividerLocation() != INT_MAX){
        	divider.setEnabled(true);
        }else{
        	divider.setEnabled(false);
        }
    }
	
	function __div_pressed(e:MouseEvent) : Void {
		if (e.target != divider){
			pressFlag = true;
			return;
		}
		spliting = true;
		showMoveCursor();
		startDragPos = sp.getMousePosition();
		startLocation = sp.getDividerLocation();
		startDividerPos = divider.getGlobalLocation();
		sp.removeEventListener(MouseEvent.MOUSE_MOVE, __div_mouse_moving);
		sp.addEventListener(MouseEvent.MOUSE_MOVE, __div_mouse_moving);
	}

	function __div_released(e:ReleaseEvent) : Void {
		if (e.getPressTarget() != divider) return;		
		if (pressFlag){
			pressFlag = false;
			return;
		}
		if(dragRepresentationMC != null && sp.contains(dragRepresentationMC)){
			sp.removeChild(dragRepresentationMC);
		}
		
		validateDivMoveWithCurrentMousePos();
		sp.removeEventListener(MouseEvent.MOUSE_MOVE, __div_mouse_moving);
		spliting = false;
		if(!mouseInDividerFlag){
			hideMoveCursor();
		}
	}

	function __div_mouse_moving(e:MouseEvent) : Void {
		if(!sp.isContinuousLayout()){
			if(dragRepresentationMC == null){
				dragRepresentationMC = new Shape();
				var g:Graphics2D = new Graphics2D(dragRepresentationMC.graphics);
				paintDividerDragingRepresention(g);
			}
			if(!sp.contains(dragRepresentationMC)){
				sp.addChild(dragRepresentationMC);
			}
			var newGlobalPos:IntPoint = startDividerPos.clone();
			if(isVertical()){
				newGlobalPos.y += getCurrentMovedDistance();
			}else{
				newGlobalPos.x += getCurrentMovedDistance();
			}
			var newPoint:Point = newGlobalPos.toPoint();
			newPoint = dragRepresentationMC.parent.globalToLocal(newPoint);
			dragRepresentationMC.x = Math.round(newPoint.x);
			dragRepresentationMC.y = Math.round(newPoint.y);
			dragRepresentationMC.width = divider.width;
			dragRepresentationMC.height = divider.height;
		}else{
			validateDivMoveWithCurrentMousePos();
		}
	}
	
	function validateDivMoveWithCurrentMousePos():Void{
		var newLocation:Int = startLocation + getCurrentMovedDistance();
		sp.setDividerLocation(newLocation);
	}
	
	function getCurrentMovedDistance():Int{
		var mouseP:IntPoint = sp.getMousePosition();
		var delta:Int = 0;
		if(isVertical()){
			delta = mouseP.y - startDragPos.y;
		}else{
			delta = mouseP.x - startDragPos.x;
		}
		var newLocation:Int = startLocation + delta;
		newLocation = Std.int(Math.max( getMinimumDividerLocation(), Math.min(newLocation, getMaximumDividerLocation())));
		return newLocation - startLocation;
	}
	
	function __div_rollover(e:MouseEvent) : Void {
		mouseInDividerFlag = true;
		if(!e.buttonDown && !spliting){
			showMoveCursor();
		}
	}

	function __div_rollout(e:Event) : Void {
		mouseInDividerFlag = false;
		if(!spliting){
			hideMoveCursor();
		}
	}
	
	var spliting:Bool ;
	var cursorManager:CursorManager;
	function showMoveCursor():Void{
		cursorManager = CursorManager.getManager(sp.stage);
		if(isVertical()){
			cursorManager.hideCustomCursor(hSplitCursor);
			cursorManager.showCustomCursor(vSplitCursor);
		}else{
			cursorManager.hideCustomCursor(vSplitCursor);
			cursorManager.showCustomCursor(hSplitCursor);
		}
	}
	
	function hideMoveCursor():Void{
		if(cursorManager == null){
			return;
		}
		cursorManager.hideCustomCursor(vSplitCursor);
		cursorManager.hideCustomCursor(hSplitCursor);
		cursorManager = null;
	}
    
    //-----------------------------------------------------------------------
    //                     Layout implementation
    //-----------------------------------------------------------------------
	public function addLayoutComponent(comp : Component, constraints : Dynamic) : Void {
	}

	public function removeLayoutComponent(comp : Component) : Void {
	}

	public function preferredLayoutSize(target : Container) : IntDimension {
		var insets:Insets = sp.getInsets();
    	var lc:Component = sp.getLeftComponent();
    	var rc:Component = sp.getRightComponent();
    	var lcSize:IntDimension = (lc == null ? new IntDimension() : lc.getPreferredSize());
    	var rcSize:IntDimension = (rc == null ? new IntDimension() : rc.getPreferredSize());
    	var size:IntDimension;
    	if(isVertical()){
    		size = new IntDimension(
    			Std.int(Math.max(lcSize.width, rcSize.width)), 
    			lcSize.height + rcSize.height + getDividerSize()
    		);
    	}else{
    		size = new IntDimension(
    			lcSize.width + rcSize.width + getDividerSize(), 
    			Std.int(Math.max(lcSize.height, rcSize.height))
    		);
    	}
    	return insets.getOutsideSize(size);
	}

	public function minimumLayoutSize(target : Container) : IntDimension {
		return target.getInsets().getOutsideSize();
	}

	public function maximumLayoutSize(target : Container) : IntDimension {
		return IntDimension.createBigDimension();
	}
	
	public function layoutContainer(target : Container) : Void {
		var size:IntDimension = sp.getSize();
		size = sp.getInsets().getInsideSize(size);
		var layouted:Bool = false;
		if(!size.equals(lastContentSize)){
			//re weight the split
			var deltaSize:Int = 0;
			if(isVertical()){
				deltaSize = size.height - lastContentSize.height;
			}else{
				deltaSize = size.width - lastContentSize.width;
			}
			lastContentSize = size.clone();
			var locationDelta:Int = Std.int(deltaSize*sp.getResizeWeight());
			layouted = (locationDelta != 0);
			var newLocation:Int = sp.getDividerLocation()+locationDelta;
			
			newLocation = Std.int(Math.max( getMinimumDividerLocation(), Math.min(newLocation, getMaximumDividerLocation())));
			
			sp.setDividerLocation(newLocation, true);
		}
		if(!layouted){
			layoutWithLocation(sp.getDividerLocation());
		}
	}

	public function getLayoutAlignmentX(target : Container) : Float {
		return 0;
	}

	public function getLayoutAlignmentY(target : Container) : Float {
		return 0;
	}

	public function invalidateLayout(target : Container) : Void {
	}
}
