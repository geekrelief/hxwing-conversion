/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;

import Import_flash_display;
import Import_flash_events;
import flash.ui.Keyboard;
import Import_org_aswing;
import Import_org_aswing_border;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;
import org.aswing.plaf.basic.icon.ArrowIcon;
import Import_org_aswing_util;
import Import_org_aswing_plaf_basic_tabbedpane;
import org.aswing.event.InteractiveEvent;
import org.aswing.event.FocusKeyEvent;

/**
 * @private
 */
class BasicTabbedPaneUI extends BaseComponentUI, implements org.aswing.LayoutManager {
	
	
	
	var topBlankSpace:Int ;
	
	var shadow:ASColor;
	var darkShadow:ASColor;
	var highlight:ASColor;
	var lightHighlight:ASColor;
	var arrowShadowColor:ASColor;
	var arrowLightColor:ASColor;
	var windowBG:ASColor;
	
	var tabbedPane:JTabbedPane;
	var tabBarSize:IntDimension;
	var maxTabSize:IntDimension;
	var prefferedSize:IntDimension;
	var minimumSize:IntDimension;
	var tabBoundArray:Array<Dynamic>;
	var drawnTabBoundArray:Array<Dynamic>;
	var contentMargin:Insets ;
	var maxTabWidth:Int ;
	var tabGap:Int ;
	//both the 3 values are just the values considering when placement is TOP
	var tabBorderInsets:Insets;
	var selectedTabExpandInsets:Insets;
	var contentRoundLineThickness:Int;
	
	var tabs:Array<Dynamic>;
	
	var firstIndex:Int; //first viewed tab index
	var lastIndex:Int;  //last perfectly viewed tab index
	var prevButton:AbstractButton;
	var nextButton:AbstractButton;
	var buttonMCPane:Container;
	
	var uiRootMC:Sprite;
	var tabBarMC:Sprite;
	var tabBarMaskMC:Shape;
	var buttonHolderMC:Sprite;
	
	public function new() {
		
		topBlankSpace = 4;
		contentMargin = null;
		maxTabWidth = -1;
		tabGap = 1;
		super();
		tabBorderInsets = new Insets(2, 2, 0, 2);
		selectedTabExpandInsets = new Insets(2, 2, 0, 2);
		tabs = new Array();
		firstIndex = 0;
		lastIndex = 0;
	}

	public override function installUI(c:Component):Void{
		tabbedPane = cast(c, JTabbedPane);
		tabbedPane.setLayout(this);
		installDefaults();
		installComponents();
		installListeners();
	}
	
	public override function uninstallUI(c:Component):Void{
		tabbedPane = cast(c, JTabbedPane);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
	}
	
    function getPropertyPrefix():String {
        return "TabbedPane.";
    }

	function installDefaults():Void{
		var pp:String = getPropertyPrefix();
		LookAndFeel.installColorsAndFont(tabbedPane, pp);
		LookAndFeel.installBorderAndBFDecorators(tabbedPane, pp);
		LookAndFeel.installBasicProperties(tabbedPane, pp);
		
		shadow = getColor(pp+"shadow");
		darkShadow = getColor(pp+"darkShadow");
		highlight = getColor(pp+"light");
		lightHighlight = getColor(pp+"highlight");
		arrowShadowColor = getColor(pp+"arrowShadowColor");
		arrowLightColor = getColor(pp+"arrowLightColor");
		windowBG = getColor("window");
		if(windowBG == null) windowBG = tabbedPane.getBackground();
		
		contentMargin = getInsets(pp+"contentMargin");
		if(contentMargin == null) contentMargin = new Insets(8, 2, 2, 2);
		maxTabWidth = getInt(pp+"maxTabWidth");
		if(maxTabWidth == -1) maxTabWidth = 1000;
		
		contentRoundLineThickness = getInt(getPropertyPrefix() + "contentRoundLineThickness");
		
		var tabMargin:Insets = getInsets(pp+"tabMargin");
		if(tabMargin == null) tabMargin = new InsetsUIResource(1, 1, 1, 1);
		
		if(containsKey(pp+"topBlankSpace")){
			topBlankSpace = getInt(pp+"topBlankSpace");
		}
		if(containsKey(pp+"tabGap")){
			tabGap = getInt(pp+"tabGap");
		}
		if(containsKey(pp+"tabBorderInsets")){
			tabBorderInsets = getInsets(pp+"tabBorderInsets");
		}
		if(containsKey(pp+"selectedTabExpandInsets")){
			selectedTabExpandInsets = getInsets(pp+"selectedTabExpandInsets");
		}
		
		var i:Insets = tabbedPane.getMargin();
		if (Std.is( i, UIResource)) {
			tabbedPane.setMargin(tabMargin);
		}
	}
	
	function uninstallDefaults():Void{
		LookAndFeel.uninstallBorderAndBFDecorators(tabbedPane);
	}
	
	function installComponents():Void{
		prevButton = createPrevButton();
		nextButton = createNextButton();
		prevButton.setFocusable(false);
		nextButton.setFocusable(false);
		prevButton.setUIElement(true);
		nextButton.setUIElement(true);
		
		prevButton.addActionListener(__prevButtonReleased);
		nextButton.addActionListener(__nextButtonReleased);
		createUIAssets();
		synTabs();
	}
	
	function uninstallComponents():Void{
		prevButton.removeActionListener(__prevButtonReleased);
		nextButton.removeActionListener(__nextButtonReleased);
		removeUIAssets();
	}
	
	function installListeners():Void{
		tabbedPane.addStateListener(__onSelectionChanged);
		tabbedPane.addEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onNavKeyDown);
		tabbedPane.addEventListener(MouseEvent.MOUSE_DOWN, __onTabPanePressed);
	}
	
	function uninstallListeners():Void{
		tabbedPane.removeStateListener(__onSelectionChanged);
		tabbedPane.removeEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onNavKeyDown);
		tabbedPane.removeEventListener(MouseEvent.MOUSE_DOWN, __onTabPanePressed);
	}
	
	//----------------------------------------------------------------
	
	function getMousedOnTabIndex():Int{
		var p:IntPoint = tabbedPane.getMousePosition();
		var n:Int = tabbedPane.getComponentCount();
		var i:Int=firstIndex;
		while (i<n && i<=lastIndex+1){
			var b:IntRectangle = getDrawnTabBounds(i);
			if(b != null && b.containsPoint(p)){
				return i;
			}
			i++;
		}
		return -1;
	}
	
	function __onSelectionChanged(e:InteractiveEvent):Void{
		tabbedPane.revalidate();
		tabbedPane.repaint();
	}
	
	function __onTabPanePressed(e:Event):Void{
		if((prevButton.hitTestMouse() || nextButton.hitTestMouse())
			&& (prevButton.isShowing() && nextButton.isShowing())){
			return;
		}
		var index:Int = getMousedOnTabIndex();
		if(index >= 0 && tabbedPane.isEnabledAt(index)){
			tabbedPane.setSelectedIndex(index, false);
		}
	}
	
	function __onNavKeyDown(e:FocusKeyEvent):Void{
		if(!tabbedPane.isEnabled()){
			return;
		}
		var n:Int = tabbedPane.getComponentCount();
		if(n > 0){
			var index:Int = tabbedPane.getSelectedIndex();
			var code:UInt = e.keyCode;
			var count:Int = 1;
			if(code == Keyboard.DOWN || code == Keyboard.RIGHT){
				setTraversingTrue();
				index++;
				while((!tabbedPane.isEnabledAt(index) || !tabbedPane.isVisibleAt(index)) && index<n){
					index++;
					count++;
					if(index >= n){
						return;
					}
				}
				if(index >= n){
					return;
				}
				if(lastIndex < n-1){
					firstIndex = Std.int(Math.min(firstIndex + count, n-1));
				}
			}else if(code == Keyboard.UP || code == Keyboard.LEFT){
				setTraversingTrue();
				index--;
				while((!tabbedPane.isEnabledAt(index) || !tabbedPane.isVisibleAt(index)) && index>=0){
					index--;
					count++;
					if(index < 0){
						return;
					}
				}
				if(index < 0){
					return;
				}
				if(firstIndex > 0){
					firstIndex = Std.int(Math.max(0, firstIndex - count));
				}
			}
			tabbedPane.setSelectedIndex(index, false);
		}
	}
    
    function setTraversingTrue():Void{
    	var fm:FocusManager = FocusManager.getManager(tabbedPane.stage);
    	if(fm != null){
    		fm.setTraversing(true);
    	}
    }
	
	function __prevButtonReleased(e:Event):Void{
		if(firstIndex > 0){
			firstIndex--;
			tabbedPane.repaint();
		}
	}
	
	function __nextButtonReleased(e:Event):Void{
		if(lastIndex < tabbedPane.getComponentCount()-1){
			firstIndex++;
			tabbedPane.repaint();
		}
	}
	
	//----------
	
	
	function isTabHorizontalPlacing():Bool{
		return tabbedPane.getTabPlacement() == JTabbedPane.TOP || tabbedPane.getTabPlacement() == JTabbedPane.BOTTOM;
	}
	/**
	 * This is just the value when placement is TOP
	 */
	function getTabBorderInsets():Insets{
		return tabBorderInsets;
	}
	
	function createPrevButton():AbstractButton{
		var b:JButton = new JButton(null, createArrowIcon(Math.PI, true));
		b.setMargin(new Insets(2, 2, 2, 2));
		b.setDisabledIcon(createArrowIcon(Math.PI, false));
		return b;
	}
	
	function createNextButton():AbstractButton{
		var b:JButton = new JButton(null, createArrowIcon(0, true));
		b.setMargin(new Insets(2, 2, 2, 2));
		b.setDisabledIcon(createArrowIcon(0, false));
		return b;
	}
	
	function createArrowIcon(direction:Float, enable:Bool):Icon{
		var icon:Icon;
		if(enable){
			icon = new ArrowIcon(direction, 8,
					arrowLightColor,
					arrowShadowColor);
		}else{
			icon = new ArrowIcon(direction, 8, 
					arrowLightColor.brighter(0.4),
					arrowShadowColor.brighter(0.4));
		}
		return icon;
	}
		
	function getTabBarSize():IntDimension{
		if(tabBarSize != null){
			return tabBarSize;
		}
		var isHorizontalPlacing:Bool = isTabHorizontalPlacing();
		tabBarSize = new IntDimension(0, 0);
		var n:Int = tabbedPane.getComponentCount();
		tabBoundArray = new Array();
		var x:Int = 0;
		var y:Int = 0;
		for(i in 0...n){
			var ts:IntDimension = countPreferredTabSizeAt(i);
			var tbounds:IntRectangle = new IntRectangle(x, y, ts.width, ts.height);
			tabBoundArray[i] = tbounds;
			var offset:Int = i < (n+1) ? tabGap : 0;
			if(isHorizontalPlacing){
				tabBarSize.height = Std.int(Math.max(tabBarSize.height, ts.height));
				tabBarSize.width += ts.width + offset;
				x += ts.width + offset;
			}else{
				tabBarSize.width = Std.int(Math.max(tabBarSize.width, ts.width));
				tabBarSize.height += ts.height + offset;
				y += ts.height + offset;
			}
		}
		maxTabSize = tabBarSize.clone();
		if(isHorizontalPlacing){
			tabBarSize.height += (topBlankSpace + contentMargin.top);
			//blank space at start and end for selected tab expanding
			tabBarSize.width += (tabBorderInsets.left + tabBorderInsets.right);
		}else{
			tabBarSize.width += (topBlankSpace + contentMargin.top);
			//blank space at start and end for selected tab expanding
			tabBarSize.height += (tabBorderInsets.left + tabBorderInsets.right);
		}
		return tabBarSize;
	}
	
	function getTabBoundArray():Array<Dynamic>{
		//when tabBoundArray.lenght != tabbedPane.getComponentCount() then recalled the getTabBarSize()
		if(tabBoundArray != null && tabBoundArray.length == tabbedPane.getComponentCount()){
			return tabBoundArray;
		}else{
			invalidateLayout(tabbedPane);
			getTabBarSize();
			if(tabBoundArray == null){
                #if debug
				trace("Debug : Error tabBoundArray == null but tabBarSize = " + tabBarSize);
                #end
			}			
			return tabBoundArray;			
		}
	}
		
	function countPreferredTabSizeAt(index:Int):IntDimension{
		var tab:Tab = getTab(index);
		var size:IntDimension = tab.getTabComponent().getPreferredSize();
		size.width = Std.int(Math.min(size.width, maxTabWidth));
		return size;
	}
	
	function setDrawnTabBounds(index:Int, b:IntRectangle, paneBounds:IntRectangle):Void{
		b = b.clone();
		if(b.x < paneBounds.x){
			b.x = paneBounds.x;
		}
		if(b.y < paneBounds.y){
			b.y = paneBounds.y;
		}
		if(b.x + b.width > paneBounds.x + paneBounds.width){
			b.width = paneBounds.x + paneBounds.width - b.x;
		}
		if(b.y + b.height > paneBounds.y + paneBounds.height){
			b.height = paneBounds.y + paneBounds.height - b.y;
		}
		drawnTabBoundArray[index] = b;
	}
	
	function getDrawnTabBounds(index:Int):IntRectangle{
		return drawnTabBoundArray[index];
	}	
	
	function createUIAssets():Void{
		uiRootMC = AsWingUtils.createSprite(tabbedPane, "uiRootMC");
		tabBarMC = AsWingUtils.createSprite(uiRootMC, "tabBarMC");
		tabBarMaskMC = AsWingUtils.createShape(uiRootMC, "tabBarMaskMC");
		buttonHolderMC = AsWingUtils.createSprite(uiRootMC, "buttonHolderMC");
		
		tabBarMC.mask = tabBarMaskMC;
		var g:Graphics2D = new Graphics2D(tabBarMaskMC.graphics);
		g.fillRectangle(new SolidBrush(ASColor.BLACK), 0, 0, 1, 1);
		
		var p:JPanel = new JPanel(new SoftBoxLayout(SoftBoxLayout.X_AXIS, 0));
		p.setOpaque(false);
		p.setFocusable(false);
		p.setSizeWH(100, 100);
		p.setUIElement(true);
		buttonHolderMC.addChild(p);
		buttonMCPane = p;
		var insets:Insets = new Insets(topBlankSpace, topBlankSpace, topBlankSpace, topBlankSpace);
		p.setBorder(new EmptyBorder(null, insets));
		p.append(prevButton);
		p.append(nextButton);
		//buttonMCPane.setVisible(false);
	}
	
	function removeUIAssets():Void{
		tabbedPane.removeChild(uiRootMC);
		tabs = new Array();
	}
	
	function createTabBarGraphics():Graphics2D{
		tabBarMC.graphics.clear();
		var g:Graphics2D = new Graphics2D(tabBarMC.graphics);
		return g;
	}
	
	function getTab(i:Int):Tab{
    	return cast(tabs[i], Tab);
	}
	
    function getSelectedTab():Tab{
    	if(tabbedPane.getSelectedIndex() >= 0){
    		return getTab(tabbedPane.getSelectedIndex());
    	}else{
    		return null;
    	}
    }
    
    function indexOfTabComponent(tab:Component):Int{
    	for(i in 0...tabs.length){
    		if(getTab(i).getTabComponent() == tab){
    			return i;
    		}
    	}
    	return -1;
    }
	
   	public override function paintFocus(c:Component, g:Graphics2D, b:IntRectangle):Void{
    	var header:Tab = getSelectedTab();
    	if(header != null){
    		header.getTabComponent().paintFocusRect(true);
    	}else{
    		super.paintFocus(c, g, b);
    	}
    }
    

    /**
     * Just override this method if you want other LAF headers.
     */
    function createNewTab():Tab{
    	var tab:Tab = cast( getInstance(getPropertyPrefix() + "tab"), Tab);
    	if(tab == null){
    		tab = new BasicTabbedPaneTab();
    	}
    	tab.initTab(tabbedPane);
    	tab.getTabComponent().setFocusable(false);
    	return tab;
    }

    function synTabs():Void{
    	var comCount:Int = tabbedPane.getComponentCount();
    	if(comCount != tabs.length){
    		var i:Int;
    		var header:Tab;
    		if(comCount > tabs.length){
    			i = tabs.length;
    			while (i<comCount){
    				header = createNewTab();
    				setTabProperties(header, i);
    				tabBarMC.addChild(header.getTabComponent());
    				tabs.push(header);
    				i++;
    			}
    		}else{
    			i = tabs.length-comCount;
    			while (i>0){
    				header = cast(tabs.pop(), Tab);
    				tabBarMC.removeChild(header.getTabComponent());
    				i--;
    			}
    		}
    	}
    }
        
    function synTabProperties():Void{
    	for(i in 0...tabs.length){
    		var header:Tab = getTab(i);
    		setTabProperties(header, i);
    	}
    }
    
    function setTabProperties(header:Tab, i:Int):Void{
		header.setTextAndIcon(tabbedPane.getTitleAt(i), tabbedPane.getIconAt(i));
		header.getTabComponent().setUIElement(true);
		header.getTabComponent().setEnabled(tabbedPane.isEnabledAt(i));
		header.getTabComponent().setVisible(tabbedPane.isVisibleAt(i));
		header.getTabComponent().setToolTipText(tabbedPane.getTipAt(i));
    	header.setHorizontalAlignment(tabbedPane.getHorizontalAlignment());
    	header.setHorizontalTextPosition(tabbedPane.getHorizontalTextPosition());
    	header.setIconTextGap(tabbedPane.getIconTextGap());
    	setTabMarginProperty(header, getTransformedMargin());
    	header.setVerticalAlignment(tabbedPane.getVerticalAlignment());
    	header.setVerticalTextPosition(tabbedPane.getVerticalTextPosition());
    	header.setFont(tabbedPane.getFont());
    	header.setForeground(tabbedPane.getForeground());
    }
    
    function setTabMarginProperty(tab:Tab, margin:Insets):Void{
    	tab.setMargin(margin); //no need here, because drawTabAt and countPreferredTabSizeAt did this work
    }
    
    function getTransformedMargin():Insets{
    	var placement:Int = tabbedPane.getTabPlacement();
    	var tabMargin:Insets = tabbedPane.getMargin();
    	var transformedTabMargin:Insets = tabMargin.clone();
		if(placement == JTabbedPane.LEFT){
			transformedTabMargin.left = tabMargin.top;
			transformedTabMargin.right = tabMargin.bottom;
			transformedTabMargin.top = tabMargin.right;
			transformedTabMargin.bottom = tabMargin.left;
		}else if(placement == JTabbedPane.RIGHT){
			transformedTabMargin.left = tabMargin.bottom;
			transformedTabMargin.right = tabMargin.top;
			transformedTabMargin.top = tabMargin.left;
			transformedTabMargin.bottom = tabMargin.right;
		}else if(placement == JTabbedPane.BOTTOM){
			transformedTabMargin.top = tabMargin.bottom;
			transformedTabMargin.bottom = tabMargin.top;
		}
		return transformedTabMargin;
    }
		
	public override function paint(c:Component, g:Graphics2D, b:IntRectangle):Void{
		super.paint(c, g, b);
		synTabProperties();
		
		tabBarMaskMC.x = b.x;
		tabBarMaskMC.y = b.y;
		tabBarMaskMC.width = b.width;
		tabBarMaskMC.height = b.height;
		g = createTabBarGraphics();
		
		var horizontalPlacing:Bool = isTabHorizontalPlacing();
	  	var contentBounds:IntRectangle = b.clone();
		var tabBarBounds:IntRectangle = getTabBarSize().getBounds(0, 0);
		tabBarBounds.x = contentBounds.x;
		tabBarBounds.y = contentBounds.y;
		tabBarBounds.width = Std.int(Math.min(tabBarBounds.width, contentBounds.width));
		tabBarBounds.height = Std.int(Math.min(tabBarBounds.height, contentBounds.height));
		var transformedTabMargin:Insets = getTransformedMargin();
		var placement:Int = tabbedPane.getTabPlacement();
		if(placement == JTabbedPane.LEFT){
			tabBarBounds.y += tabBorderInsets.left;//extra for expand 
		}else if(placement == JTabbedPane.RIGHT){
			tabBarBounds.x = contentBounds.x + contentBounds.width - tabBarBounds.width;
			tabBarBounds.y += tabBorderInsets.left;//extra for expand 
		}else if(placement == JTabbedPane.BOTTOM){
			tabBarBounds.y = contentBounds.y + contentBounds.height - tabBarBounds.height;
			tabBarBounds.x += tabBorderInsets.left;//extra for expand 
		}else{ //others value are all considered as TOP
			tabBarBounds.x += tabBorderInsets.left;//extra for expand
		}
		
		var i:Int = 0;
		var n:Int = tabbedPane.getComponentCount();
		var tba:Array<Dynamic> = getTabBoundArray();
		drawnTabBoundArray = new Array();
		var selectedIndex:Int = tabbedPane.getSelectedIndex();
		
		//count not viewed front tabs's width and invisible them
		var offsetPoint:IntPoint = new IntPoint();
		for(i in 0...firstIndex){
			if(horizontalPlacing){
				offsetPoint.x -= tba[i].width;
			}else{
				offsetPoint.y -= tba[i].height;
			}
			getTab(i).getTabComponent().setVisible(false);
		}
		//draw from firstIndex to last viewable tabs
		i=firstIndex;
		while (i<n){
			if(i != selectedIndex){
				var viewedFlag:Int = drawTabWithFullInfosAt(i, b, tba[i], g, tabBarBounds, offsetPoint, transformedTabMargin);
				if(viewedFlag < 0){
					lastIndex = i;
				}
				if(viewedFlag >= 0){
					break;
				}
			}
			i++;
		}
		drawBaseLine(tabBarBounds, g, b);
		if(selectedIndex >= 0){
			if(drawTabWithFullInfosAt(selectedIndex, b, tba[selectedIndex], g, tabBarBounds, offsetPoint, transformedTabMargin) < 0){
				lastIndex = Std.int(Math.max(lastIndex, selectedIndex));
			}
		}
		//invisible tab after last
		for(i in 2...n){
			getTab(i).getTabComponent().setVisible(false);
		}
		
		//view prev and next buttons
		if(firstIndex > 0 || lastIndex < n-1){
			buttonMCPane.setVisible(true);
			prevButton.setEnabled(firstIndex > 0);
			nextButton.setEnabled(lastIndex < n-1);
			var bps:IntDimension = buttonMCPane.getPreferredSize();
			buttonMCPane.setSize(bps);
			var bpl:IntPoint = new IntPoint();
			if(placement == JTabbedPane.LEFT){
				bpl.x = contentBounds.x;
				bpl.y = contentBounds.y + contentBounds.height - bps.height;
			}else if(placement == JTabbedPane.RIGHT){
				bpl.x = contentBounds.x + contentBounds.width - bps.width;
				bpl.y = contentBounds.y + contentBounds.height - bps.height;
			}else if(placement == JTabbedPane.BOTTOM){
				bpl.x = contentBounds.x + contentBounds.width - bps.width;
				bpl.y = contentBounds.y + contentBounds.height - bps.height;
			}else{
				bpl.x = contentBounds.x + contentBounds.width - bps.width;
				bpl.y = contentBounds.y;
			}
			buttonMCPane.setLocation(bpl);
			buttonMCPane.revalidate();
		}else{
			buttonMCPane.setVisible(false);
		}
		tabbedPane.bringToTop(uiRootMC);//make it at top
	}
	
	/**
	 * Returns whether the tab painted out of tabbedPane bounds or not viewable or viewable.<br>
	 * @return -1 , viewable whole area;
	 *		 0, viewable but end out of bounds
	 *		 1, not viewable in the bounds. 
	 */
	function drawTabWithFullInfosAt(index:Int, paneBounds:IntRectangle, bounds:IntRectangle,
	 g:Graphics2D, tabBarBounds:IntRectangle, offsetPoint:IntPoint, transformedTabMargin:Insets):Int{
		var tb:IntRectangle = bounds.clone();
		tb.x += (tabBarBounds.x + offsetPoint.x);
		tb.y += (tabBarBounds.y + offsetPoint.y);
		var placement:Int = tabbedPane.getTabPlacement();
		if(placement == JTabbedPane.LEFT){
			tb.width = maxTabSize.width;
			tb.x += topBlankSpace;
		}else if(placement == JTabbedPane.RIGHT){
			tb.width = maxTabSize.width;
			tb.x += contentMargin.top;
		}else if(placement == JTabbedPane.BOTTOM){
			tb.y += contentMargin.top;
			tb.height = maxTabSize.height;
		}else{
			tb.height = maxTabSize.height;
			tb.y += topBlankSpace;
		}
		if(isTabHorizontalPlacing()){
			if(tb.x > paneBounds.x + paneBounds.width){
				//do not need paint
				return 1;
			}
		}else{
			if(tb.y > paneBounds.y + paneBounds.height){
				//do not need paint
				return 1;
			}
		}
		drawTabAt(index, tb, paneBounds, g, transformedTabMargin);
		if(isTabHorizontalPlacing()){
			if(tb.x + tb.width > paneBounds.x + paneBounds.width){
				return 0;
			}
		}else{
			if(tb.y + tb.height > paneBounds.y + paneBounds.height){
				return 0;
			}
		}
		return -1;
	}
	

    /**
     * override this method to draw different tab base line for your LAF
     */
    function drawBaseLine(tabBarBounds:IntRectangle, g:Graphics2D, fullB:IntRectangle):Void{
    	var b:IntRectangle = tabBarBounds.clone();
    	var placement:Int = tabbedPane.getTabPlacement();
    	var pen:Pen;
    	var lineT:Int = contentRoundLineThickness;
    	var hlt:Int = Std.int(lineT/2);
    	if(isTabHorizontalPlacing()){
    		var isTop:Bool = (placement == JTabbedPane.TOP);
    		if(isTop){
    			b.y = b.y + b.height - contentMargin.top;
    		}
    		b.height = contentMargin.top;
    		b.width = fullB.width;
    		b.x = fullB.x;
    		BasicGraphicsUtils.fillGradientRect(g, b, 
    			tabbedPane.getBackground(), windowBG, 
    			isTop ? Math.PI/2 : -Math.PI/2);
    		pen = new Pen(darkShadow, lineT);
    		pen.setCaps(CapsStyle.SQUARE);
			if(isTop){
				g.drawRectangle(pen, b.x+hlt, b.y+hlt, fullB.width-lineT, fullB.rightBottom().y - b.y-lineT);
			}else{
				g.drawRectangle(pen, fullB.x+hlt, fullB.y+hlt, fullB.width-lineT, b.y+b.height-fullB.y-lineT);
			}
    	}else{
    		var isLeft:Bool = (placement == JTabbedPane.LEFT);
    		if(isLeft){
    			b.x = b.x + b.width - contentMargin.top;
    		}
    		b.width = contentMargin.top;
    		b.height = fullB.height;
    		b.y = fullB.y;
    		
    		BasicGraphicsUtils.fillGradientRect(g, b, 
    			tabbedPane.getBackground(), windowBG, 
    			isLeft ? 0 : -Math.PI);
    		pen = new Pen(darkShadow, lineT);
    		pen.setCaps(CapsStyle.SQUARE);
			if(isLeft){
    			g.drawRectangle(pen, b.x+hlt, b.y+hlt, fullB.rightTop().x-b.x-lineT, b.height-lineT);
			}else{
				g.drawRectangle(pen, fullB.x+hlt, fullB.y+hlt, b.x+b.width-fullB.x-lineT, b.height-lineT);
			}
    		
    	}
    }	
	
    /**
     * override this method to draw different tab border for your LAF.<br>
     * Note, you must call setDrawnTabBounds() to set the right bounds for each tab in this method
     */
    function drawTabBorderAt(index:Int, b:IntRectangle, paneBounds:IntRectangle, g:Graphics2D):Void{
    	var placement:Int = tabbedPane.getTabPlacement();
    	var pen:Pen;
    	b = b.clone();//make a clone to be safty modification
    	if(index == tabbedPane.getSelectedIndex()){
    		if(isTabHorizontalPlacing()){
    			b.x -= selectedTabExpandInsets.left;
    			b.width += (selectedTabExpandInsets.left + selectedTabExpandInsets.right);
	    		b.height += Math.round(topBlankSpace/2+contentRoundLineThickness);
    			if(placement == JTabbedPane.BOTTOM){
	    			b.y -= contentRoundLineThickness;
    			}else{
	    			b.y -= Math.round(topBlankSpace/2);
    			}
    		}else{
    			b.y -= selectedTabExpandInsets.left;
    			b.height += (selectedTabExpandInsets.left + selectedTabExpandInsets.right);
	    		b.width += Math.round(topBlankSpace/2+contentRoundLineThickness);
    			if(placement == JTabbedPane.RIGHT){
	    			b.x -= contentRoundLineThickness;
    			}else{
	    			b.x -= Math.round(topBlankSpace/2);
    			}
    		}
    	}
    	//This is important, should call this in sub-implemented drawTabBorderAt method
    	setDrawnTabBounds(index, b, paneBounds);
    	var x1:Float = b.x+0.5;
    	var y1:Float = b.y+0.5;
    	var x2:Float = b.x + b.width-0.5;
    	var y2:Float = b.y + b.height-0.5;
    	if(placement == JTabbedPane.LEFT){
    		BasicGraphicsUtils.drawControlBackground(g, b, getTabColor(index), Math.PI/2);
    		
    		pen = new Pen(darkShadow, 1);
    		pen.setCaps(CapsStyle.SQUARE);
    		g.beginDraw(pen);
    		g.moveTo(x2, y1);
    		g.lineTo(x1, y1);
    		g.lineTo(x1, y2);
    		g.lineTo(x2, y2);
    		g.endDraw();
    	}else if(placement == JTabbedPane.RIGHT){
    		BasicGraphicsUtils.drawControlBackground(g, b, getTabColor(index), Math.PI/2);
    		
    		pen = new Pen(darkShadow, 1);
    		pen.setCaps(CapsStyle.SQUARE);
    		g.beginDraw(pen);
    		g.moveTo(x1, y1);
    		g.lineTo(x2, y1);
    		g.lineTo(x2, y2);
    		g.lineTo(x1, y2);
    		g.endDraw();
    	}else if(placement == JTabbedPane.BOTTOM){
    		BasicGraphicsUtils.drawControlBackground(g, b, getTabColor(index), -Math.PI/2);
    		
    		pen = new Pen(darkShadow, 1);
    		pen.setCaps(CapsStyle.SQUARE);
    		g.beginDraw(pen);
    		g.moveTo(x1, y1);
    		g.lineTo(x1, y2);
    		g.lineTo(x2, y2);
    		g.lineTo(x2, y1);
    		g.endDraw();
    	}else{
    		BasicGraphicsUtils.drawControlBackground(g, b, getTabColor(index), Math.PI/2);
    		
    		pen = new Pen(darkShadow, 1);
    		pen.setCaps(CapsStyle.SQUARE);
    		g.beginDraw(pen);
    		g.moveTo(x1, y2);
    		g.lineTo(x1, y1);
    		g.lineTo(x2, y1);
    		g.lineTo(x2, y2);
    		g.endDraw();
    		//removed below make it cleaner than button style
//    		x1 += 1;
//    		y1 += 1;
//    		x2 -=1;
//    		y2 -=1;
//    		pen = new Pen(highlight, 1);
//    		g.beginDraw(pen);
//    		g.moveTo(x1, y2);
//    		g.lineTo(x1, y1);
//    		g.lineTo(x2, y1);
//    		g.endDraw();
//    		pen = new Pen(shadow, 1);
//    		g.beginDraw(pen);
//    		g.moveTo(x1, y1);
//    		g.lineTo(x2, y1);
//    		g.lineTo(x2, y2);
//    		g.endDraw();
    	}
    }	
	
	function drawTabAt(index:Int, bounds:IntRectangle, paneBounds:IntRectangle, g:Graphics2D, transformedTabMargin:Insets):Void{
		//trace("drawTabAt : " + index + ", bounds : " + bounds + ", g : " + g);
		drawTabBorderAt(index, bounds, paneBounds, g);
		
		var viewRect:IntRectangle = bounds;//transformedTabMargin.getInsideBounds(bounds);
		var tab:Tab = getTab(index);
		tab.getTabComponent().setComBounds(viewRect);
		tab.getTabComponent().validate();
	}
	
	function getTabColor(index:Int):ASColor{
		return tabbedPane.getBackground();
	}
	
	//----------------------------LayoutManager Implementation-----------------------------
	
	public function addLayoutComponent(comp:Component, constraints:Dynamic):Void{
		tabbedPane.repaint();
		synTabs();
		synTabProperties();
	}
	
	public function removeLayoutComponent(comp:Component):Void{
		tabbedPane.repaint();
		synTabs();
		synTabProperties();
	}
	
	public function preferredLayoutSize(target:Container):IntDimension{
		if(target != tabbedPane){
            #if debug
			trace("Error : BasicTabbedPaneUI Can't layout " + target);
            #end
			return null;
		}
		if(prefferedSize != null){
			return prefferedSize;
		}
		var insets:Insets = tabbedPane.getInsets();
		
		var w:Int = 0;
		var h:Int = 0;
		
		var i:Int=tabbedPane.getComponentCount()-1;
		while (i>=0){
			var size:IntDimension = tabbedPane.getComponent(i).getPreferredSize();
			w = Std.int(Math.max(w, size.width));
			h = Std.int(Math.max(h, size.height));
			i--;
		}
		var tbs:IntDimension = getTabBarSize();
		if(isTabHorizontalPlacing()){
			w = Std.int(Math.max(w, tbs.width));
			h += tbs.height;
		}else{
			h = Std.int(Math.max(h, tbs.height));
			w += tbs.width;
		}
		
		prefferedSize = contentMargin.getOutsideSize(insets.getOutsideSize(new IntDimension(w, h)));
		return prefferedSize;
	}

	public function minimumLayoutSize(target:Container):IntDimension{
		if(target != tabbedPane){
            #if debug
			trace("Error : BasicTabbedPaneUI Can't layout " + target);
            #end
			return null;
		}
		if(minimumSize != null){
			return minimumSize;
		}
		var insets:Insets = tabbedPane.getInsets();
		
		var w:Int = 0;
		var h:Int = 0;
		
		var i:Int=tabbedPane.getComponentCount()-1;
		while (i>=0){
			var size:IntDimension = tabbedPane.getComponent(i).getMinimumSize();
			w = Std.int(Math.max(w, size.width));
			h = Std.int(Math.max(h, size.height));
			i--;
		}
		var tbs:IntDimension = getTabBarSize();
		if(isTabHorizontalPlacing()){
			h += tbs.height;
		}else{
			w += tbs.width;
		}
		
		minimumSize = contentMargin.getOutsideSize(insets.getOutsideSize(new IntDimension(w, h)));
		return minimumSize;
	}

	public function maximumLayoutSize(target:Container):IntDimension{
		if(target != tabbedPane){
            #if debug
			trace("Error : BasicTabbedPaneUI Can't layout " + target);
            #end
			return null;
		}
		return IntDimension.createBigDimension();
	}
		
	public function layoutContainer(target:Container):Void{
		if(target != tabbedPane){
            #if debug
			trace("Error : BasicTabbedPaneUI Can't layout " + target);
            #end
			return;
		}
		var n:Int = tabbedPane.getComponentCount();
		var selectedIndex:Int = tabbedPane.getSelectedIndex();
		
		var insets:Insets = tabbedPane.getInsets();
		var paneBounds:IntRectangle = insets.getInsideBounds(new IntRectangle(0, 0, tabbedPane.getWidth(), tabbedPane.getHeight()));
		var tbs:IntDimension = getTabBarSize();
		if(isTabHorizontalPlacing()){
			paneBounds.height -= (tbs.height + contentMargin.bottom);
			paneBounds.x += contentMargin.left;
			paneBounds.width -= (contentMargin.left + contentMargin.right);
		}else{
			paneBounds.width -= (tbs.width + contentMargin.bottom);
			paneBounds.y += contentMargin.right;
			paneBounds.height -= (contentMargin.left + contentMargin.right);
		}
		var placement:Int = tabbedPane.getTabPlacement();
		if(placement == JTabbedPane.LEFT){
			paneBounds.x += tbs.width;
		}else if(placement == JTabbedPane.RIGHT){
			paneBounds.x += contentMargin.bottom;
		}else if(placement == JTabbedPane.BOTTOM){
			paneBounds.y += contentMargin.bottom;
		}else{ //others value are all considered as TOP
			paneBounds.y += tbs.height;
		}
		
		for(i in 0...n){
			tabbedPane.getComponent(i).setBounds(paneBounds);
			tabbedPane.getComponent(i).setVisible(i == selectedIndex);
		}
	}
	
	public function invalidateLayout(target:Container):Void{
		if(target != tabbedPane){
            #if debug
			trace("Error : BasicTabbedPaneUI Can't layout " + target);
            #end
			return;
		}
		prefferedSize = null;
		minimumSize = null;
		tabBarSize = null;
		tabBoundArray = null;
		synTabProperties();
	}
	
	public function getLayoutAlignmentX(target:Container):Float{
		return 0;
	}
	
	public function getLayoutAlignmentY(target:Container):Float{
		return 0;
	}	
}
