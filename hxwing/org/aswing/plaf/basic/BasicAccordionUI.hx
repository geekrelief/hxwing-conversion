/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;
	
import flash.display.Sprite;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.ui.Keyboard;
import flash.utils.Timer;

import Import_org_aswing;
import org.aswing.event.FocusKeyEvent;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;
import Import_org_aswing_plaf_basic_accordion;
import org.aswing.plaf.basic.tabbedpane.Tab;

/**
 * Basic accordion ui imp.
 * @author iiley
 * @private
 */
class BasicAccordionUI extends BaseComponentUI, implements org.aswing.LayoutManager {
	
	
	
	static var MOTION_SPEED:Int = 50;
	
	var accordion:JAccordion;
	var headers:Array<Dynamic>;
	var motionTimer:Timer;
	var headerDestinations:Array<Dynamic>;
	var childrenDestinations:Array<Dynamic>;
	var childrenOrderYs:Array<Dynamic>;
	var destSize:IntDimension;
	var motionSpeed:Int;
	
	var headerContainer:Sprite;
	
	public function new(){
		super();
	}
	
    public override function installUI(c:Component):Void{
    	headers = new Array();
    	destSize = new IntDimension();
    	accordion = cast(c, JAccordion);
		installDefaults();
		installComponents();
		installListeners();
    }
    
	public override function uninstallUI(c:Component):Void{
    	accordion = cast(c, JAccordion);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
    }
    
	function getPropertyPrefix():String {
		return "Accordion.";
	}
	
	function installDefaults():Void{
		accordion.setLayout(this);
		var pp:String = getPropertyPrefix();
        LookAndFeel.installBorderAndBFDecorators(accordion, pp);
        LookAndFeel.installColorsAndFont(accordion, pp);
        LookAndFeel.installBasicProperties(accordion, pp);
        motionSpeed = getInt(pp + "motionSpeed");
        if(motionSpeed <=0 || Math.isNaN(motionSpeed)){
        	motionSpeed = MOTION_SPEED;
        }
       	var tabMargin:Insets = getInsets(pp + "tabMargin");
		if(tabMargin == null){
			tabMargin = new InsetsUIResource(1, 1, 1, 1);	
		}
		var i:Insets = accordion.getMargin();
		if (i == null || Std.is( i, UIResource)) {
	    	accordion.setMargin(tabMargin);
		}
	}
    
    function uninstallDefaults():Void{
    	LookAndFeel.uninstallBorderAndBFDecorators(accordion);
    }
    
	function installComponents():Void{
		headerContainer = new Sprite();
		headerContainer.tabEnabled = false;
		accordion.addChild(headerContainer);
		synTabs();
		synHeaderProperties();
    }
    
	function uninstallComponents():Void{
		for(i in 0...headers.length){
			var header:Tab = getHeader(i);
			headerContainer.removeChild(header.getTabComponent());
    		header.getTabComponent().removeEventListener(MouseEvent.CLICK, __tabClick);
		}
		headers.splice(0, headers.length);
		accordion.removeChild(headerContainer);
    }
	
	function installListeners():Void{
		accordion.addStateListener(__onSelectionChanged);
		accordion.addEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onKeyDown);
		motionTimer = new Timer(40);
		motionTimer.addEventListener(TimerEvent.TIMER, __onMotion);
	}
    
    function uninstallListeners():Void{
		accordion.removeStateListener(__onSelectionChanged);
		accordion.removeEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onKeyDown);
		motionTimer.stop();
		motionTimer = null;
    }
    
   	public override function paintFocus(c:Component, g:Graphics2D, b:IntRectangle):Void{
    	var header:Tab = getSelectedHeader();
    	if(header != null){
    		header.getTabComponent().paintFocusRect(true);
    	}else{
    		super.paintFocus(c, g, b);
    	}
    } 
    
	public override function paint(c:Component, g:Graphics2D, b:IntRectangle):Void{
    	super.paint(c, g, b);
    }
    
    /**
     * Just override this method if you want other LAF headers.
     */
    function createNewHeader():Tab{
    	var header:Tab = cast( getInstance(getPropertyPrefix() + "header"), Tab);
    	if(header == null){
    		header = new BasicAccordionHeader();
    	}
    	header.initTab(accordion);
    	header.getTabComponent().setFocusable(false);
    	return header;
    }
        
    function getHeader(i:Int):Tab{
    	return cast(headers[i], Tab);
    }

    function synTabs():Void{
    	var comCount:Int = accordion.getComponentCount();
    	if(comCount != headers.length){
    		var i:Int;
    		var header:Tab;
    		if(comCount > headers.length){
    			i = headers.length;
    			while (i<comCount){
    				header = createNewHeader();
    				header.setTextAndIcon(accordion.getTitleAt(i), accordion.getIconAt(i));
    				setHeaderProperties(header);
    				header.getTabComponent().setToolTipText(accordion.getTipAt(i));
    				header.getTabComponent().addEventListener(MouseEvent.CLICK, __tabClick);
    				headerContainer.addChild(header.getTabComponent());
    				headers.push(header);
    				i++;
    			}
    		}else{
    			i = headers.length-comCount;
    			while (i>0){
    				header = cast(headers.pop(), Tab);
    				header.getTabComponent().removeEventListener(MouseEvent.CLICK, __tabClick);
    				headerContainer.removeChild(header.getTabComponent());
    				i--;
    			}
    		}
    	}
    }
        
    function synHeaderProperties():Void{
    	for(i in 0...headers.length){
    		var header:Tab = getHeader(i);
    		header.setTextAndIcon(accordion.getTitleAt(i), accordion.getIconAt(i));
    		setHeaderProperties(header);
    		header.getTabComponent().setUIElement(true);
    		header.getTabComponent().setEnabled(accordion.isEnabledAt(i));
    		header.getTabComponent().setVisible(accordion.isVisibleAt(i));
    		header.getTabComponent().setToolTipText(accordion.getTipAt(i));
    	}
    }
    
    function setHeaderProperties(header:Tab):Void{
    	header.setHorizontalAlignment(accordion.getHorizontalAlignment());
    	header.setHorizontalTextPosition(accordion.getHorizontalTextPosition());
    	header.setIconTextGap(accordion.getIconTextGap());
    	header.setMargin(accordion.getMargin());
    	header.setVerticalAlignment(accordion.getVerticalAlignment());
    	header.setVerticalTextPosition(accordion.getVerticalTextPosition());
    	header.setFont(accordion.getFont());
    	header.setForeground(accordion.getForeground());
    }
    
    function ensureHeadersOnTopDepths():Void{
    	accordion.bringToTop(headerContainer);
    }
    
    function getSelectedHeader():Tab{
    	if(accordion.getSelectedIndex() >= 0){
    		return getHeader(accordion.getSelectedIndex());
    	}else{
    		return null;
    	}
    }
    
    function indexOfHeaderComponent(tab:Component):Int{
    	for(i in 0...headers.length){
    		if(getHeader(i).getTabComponent() == tab){
    			return i;
    		}
    	}
    	return -1;
    }
    
    //------------------------------Handlers--------------------------------
    
    function __tabClick(e:Event):Void{
    	accordion.setSelectedIndex(indexOfHeaderComponent(cast( e.currentTarget, Component)));
    }
    
    function __onSelectionChanged(e:Event):Void{
    	accordion.revalidate();
    	accordion.repaint();
    }
    
    function __onKeyDown(e:FocusKeyEvent):Void{
    	if(headers.length > 0){
    		var n:Int = accordion.getComponentCount();
    		var code:UInt = e.keyCode;
    		var index:Int;
	    	if(code == Keyboard.DOWN){
	    		setTraversingTrue();
		    	index = accordion.getSelectedIndex();
		    	index++;
		    	while(index<n && (!accordion.isEnabledAt(index) || !accordion.isVisibleAt(index))){
		    		index++;
		    	}
		    	if(index >= n){
		    		return;
		    	}
		    	accordion.setSelectedIndex(index);
	    	}else if(code == Keyboard.UP){
	    		setTraversingTrue();
		    	index = accordion.getSelectedIndex();
		    	index--;
		    	while(index >= 0 && (!accordion.isEnabledAt(index) || !accordion.isVisibleAt(index))){
		    		index--;
		    	}
		    	if(index < 0){
		    		return;
		    	}
		    	accordion.setSelectedIndex(index);
	    	}
    	}
    }
    
    function setTraversingTrue():Void{
    	var fm:FocusManager = FocusManager.getManager(accordion.stage);
    	if(fm != null){
    		fm.setTraversing(true);
    	}
    }
    
    function __onMotion(e:TimerEvent):Void{
    	var isFinished:Bool = true;
    	var n:Int = headerDestinations.length;
    	var selected:Int = accordion.getSelectedIndex();
    	var i:Int = 0;
    	var child:Component;
    	
    	for(i in 0...n){
    		var header:Tab = getHeader(i);
    		var tab:Component = header.getTabComponent();
    		var curY:Int = tab.getY();
    		var desY:Int = headerDestinations[i];
    		var toY:Int;
    		if(Math.abs(desY - curY) <= motionSpeed){
    			toY = desY;
    		}else{
    			if(desY > curY){
    				toY = curY + motionSpeed;
    			}else{
    				toY = curY - motionSpeed;
    			}
    			isFinished = false;
    		}
    		tab.setLocationXY(tab.getX(), toY);
    		tab.validate();
    		child = accordion.getComponent(i);
    		child.setLocationXY(child.getX(), toY + tab.getHeight());
    	}
    	
    	adjustClipSizes();
    	
    	if(isFinished){
    		motionTimer.stop();
    		for(i in 0...n){
	    		child = accordion.getComponent(i);
	    		if(selected == i){
	    			child.setVisible(true);
	    		}else{
	    			child.setVisible(false);
	    		}
    		}
    	}
    	
    	for(i in 0...n){
    		child = accordion.getComponent(i);
    		child.validate();
    	}
    	if(e != null)
    		e.updateAfterEvent();
    }
    
    function adjustClipSizes():Void{
    	var n:Int = headerDestinations.length;
    	for(i in 0...n){
    		var child:Component = accordion.getComponent(i);
    		var orderY:Int = childrenOrderYs[i];
    		if(child.isVisible()){
    			child.setClipSize(new IntDimension(destSize.width, destSize.height - (child.getY()-orderY)));
    		}
    	}
    }
    
	//---------------------------LayoutManager Imp-------------------------------
	
	public function addLayoutComponent(comp:Component, constraints:Dynamic):Void{
		synTabs();
	}
	
	public function removeLayoutComponent(comp:Component):Void{
		synTabs();
	}
	
	public function invalidateLayout(target:Container):Void{
	}
	
	public function layoutContainer(target:Container):Void{
    	synHeaderProperties();
    	
    	var insets:Insets = accordion.getInsets();
    	var i:Int = 0;
    	var x:Int = insets.left;
    	var y:Int = insets.top;
    	var w:Int = accordion.getWidth() - x - insets.right;
    	var h:Int = accordion.getHeight() - y - insets.bottom;
		var header:Tab;
		var tab:Component;
		var size:IntDimension;
		
    	var count:Int = accordion.getComponentCount();
    	var selected:Int = accordion.getSelectedIndex();
    	if(selected < 0){
    		if(count > 0){
    			accordion.setSelectedIndex(0);
    		}
    		return;
    	}
    	
    	headerDestinations = new Array();
    	childrenOrderYs = new Array();
    	
    	var vX:Int, vY:Int, vWidth:Int, vHeight:Int;
    	vHeight = h;
    	vWidth = w;
    	vX = x;
    	i=0;
    	while (i<=selected){
    		if (!accordion.isVisibleAt(i)) continue;
    		header = getHeader(i);
    		tab = header.getTabComponent();
    		size = tab.getPreferredSize();
    		tab.setSizeWH(w, size.height);
    		tab.setLocationXY(x, tab.getY());
    		accordion.getComponent(i).setLocationXY(x, tab.getY()+size.height);
    		headerDestinations[i] = y;
    		y += size.height;
    		childrenOrderYs[i] = y;
    		vHeight -= size.height;
    		if(i == selected){
    			header.setSelected(true);
    			accordion.getComponent(i).setVisible(true);
    		}else{
    			header.setSelected(false);
    		}
    		tab.validate();
    		i++;
    	}
    	vY = y;
    	for(i in 1...count){
    		if (!accordion.isVisibleAt(i)) continue;
    		header = getHeader(i);
    		tab = header.getTabComponent();
    		y += tab.getPreferredSize().height;
    		childrenOrderYs[i] = y;
    	}
    	
    	y = accordion.getHeight() - insets.bottom;
    	i=count-1;
    	while (i>selected){
    		if (!accordion.isVisibleAt(i)) continue;
    		header = getHeader(i);
    		tab = header.getTabComponent();
    		size = tab.getPreferredSize();
    		y -= size.height;
    		headerDestinations[i] = y;
    		tab.setSizeWH(w, size.height);
    		tab.setLocationXY(x, tab.getY());
    		accordion.getComponent(i).setLocationXY(x, tab.getY()+size.height);
    		header.setSelected(false);
    		vHeight -= size.height;
    		tab.validate();
    		i--;
    	}
    	destSize.setSizeWH(vWidth, vHeight);
    	for(i in 0...count){
    		if (!accordion.isVisibleAt(i)) continue;
    		if(accordion.getComponent(i).isVisible()){
    			accordion.getComponent(i).setSize(destSize);
    		}
    	}
    	motionTimer.start();
    	__onMotion(null);
    	ensureHeadersOnTopDepths();
	}
	
	public function preferredLayoutSize(target:Container):IntDimension{
    	if(target == accordion){
    		synHeaderProperties();
    		
	    	var insets:Insets = accordion.getInsets();
	    	
	    	var w:Int = 0;
	    	var h:Int = 0;
	    	var i:Int = 0;
	    	var size:IntDimension;
	    	
	    	i=accordion.getComponentCount()-1;
	    	while (i>=0){
	    		size = accordion.getComponent(i).getPreferredSize();
	    		w = Std.int(Math.max(w, size.width));
	    		h = Std.int(Math.max(h, size.height));
	    		i--;
	    	}
	    	
	    	i=accordion.getComponentCount()-1;
	    	while (i>=0){
	    		size = getHeader(i).getTabComponent().getPreferredSize();
	    		w = Std.int(Math.max(w, size.width));
	    		h += size.height;
	    		i--;
	    	}
	    	
	    	return insets.getOutsideSize(new IntDimension(w, h));
    	}
    	return null;
	}
	
	public function minimumLayoutSize(target:Container):IntDimension{
    	if(target == accordion){
    		synHeaderProperties();
    		
	    	var insets:Insets = accordion.getInsets();
	    	
	    	var w:Int = 0;
	    	var h:Int = 0;
	    	var i:Int = 0;
	    	var size:IntDimension;
	    	
	    	i=accordion.getComponentCount()-1;
	    	while (i>=0){
	    		size = accordion.getComponent(i).getMinimumSize();
	    		w = Std.int(Math.max(w, size.width));
	    		h = Std.int(Math.max(h, size.height));
	    		i--;
	    	}
	    	
	    	i=accordion.getComponentCount()-1;
	    	while (i>=0){
	    		size = getHeader(i).getTabComponent().getMinimumSize();
	    		w = Std.int(Math.max(w, size.width));
	    		h += size.height;
	    		i--;
	    	}
	    	
	    	return insets.getOutsideSize(new IntDimension(w, h));
    	}
    	return null;
	}
	
	public function maximumLayoutSize(target:Container):IntDimension
	{
		return IntDimension.createBigDimension();
	}
	
	public function getLayoutAlignmentX(target:Container):Float{
		return 0;
	}
	
	public function getLayoutAlignmentY(target:Container):Float{
		return 0;
	}
	
	public override function getMaximumSize(c:Component):IntDimension{
		return maximumLayoutSize(accordion);
	}
	
	public override function getMinimumSize(c:Component):IntDimension{
		return minimumLayoutSize(accordion);
	}
	
	public override function getPreferredSize(c:Component):IntDimension{
		return preferredLayoutSize(accordion);
	}	
	
}
