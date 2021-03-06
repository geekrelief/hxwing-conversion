/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;

import Import_flash_display;
import flash.events.Event;
import flash.events.MouseEvent;
import Import_flash_text;

import Import_org_aswing;
import org.aswing.event.AWEvent;
import Import_org_aswing_geom;
import Import_org_aswing_graphics;
import Import_org_aswing_plaf;

/**
 * @private
 * @author iiley
 */
class BasicMenuItemUI extends BaseComponentUI, implements MenuElementUI {
		
	/* Client Property keys for text and accelerator text widths */
	
		
	/* Client Property keys for text and accelerator text widths */
	public static var MAX_TEXT_WIDTH:String =  "maxTextWidth";
	public static var MAX_ACC_WIDTH:String  =  "maxAccWidth";
	
	var menuItem:JMenuItem;
	
	var selectionBackground:ASColor;
	var selectionForeground:ASColor;	
	var disabledForeground:ASColor;
	var acceleratorForeground:ASColor;
	var acceleratorSelectionForeground:ASColor;
	
	var defaultTextIconGap:Int;
	var acceleratorFont:ASFont;
	var acceleratorFontValidated:Bool;

	var arrowIcon:Icon;
	var checkIcon:Icon;
	
	var textField:TextField;
	var accelTextField:TextField;
	
	var menuItemLis:Dynamic;
	
	public function new() {
		super();
	}
	
	public override function installUI(c:Component):Void {
		menuItem = cast(c, JMenuItem);
		installDefaults();
		installComponents();
		installListeners();
	}

	public override function uninstallUI(c:Component):Void {
		menuItem = cast(c, JMenuItem);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
	}

	function getPropertyPrefix():String {
		return "MenuItem.";
	}	

	function installDefaults():Void {
		menuItem.setHorizontalAlignment(AsWingConstants.LEFT);
		menuItem.setVerticalAlignment(AsWingConstants.CENTER);
		var pp:String = getPropertyPrefix();
        LookAndFeel.installColorsAndFont(menuItem, pp);
        LookAndFeel.installBorderAndBFDecorators(menuItem, pp);
        LookAndFeel.installBasicProperties(menuItem, pp);
		
		selectionBackground = getColor(pp + "selectionBackground");
		selectionForeground = getColor(pp + "selectionForeground");
		disabledForeground = getColor(pp + "disabledForeground");
		acceleratorForeground = getColor(pp + "acceleratorForeground");
		acceleratorSelectionForeground = getColor(pp + "acceleratorSelectionForeground");
		acceleratorFont = getFont(pp + "acceleratorFont");
		acceleratorFontValidated = false;
		
		if(Std.is( menuItem.getMargin(), UIResource)) {
			menuItem.setMargin(getInsets(pp + "margin"));
		}
		
		arrowIcon = getIcon(pp + "arrowIcon");
		checkIcon = getIcon(pp + "checkIcon");
		installIcon(arrowIcon);
		installIcon(checkIcon);
		
		//TODO get this from UI defaults
		defaultTextIconGap = 4;
	}
	
	function installIcon(icon:Icon):Void{
		if(icon != null && icon.getDisplay(menuItem) != null){
			menuItem.addChild(icon.getDisplay(menuItem));
		}
	}
	
	function uninstallIcon(icon:Icon):Void{
		if(icon != null && icon.getDisplay(menuItem) != null){
			menuItem.removeChild(icon.getDisplay(menuItem));
		}
	}
	
	function installComponents():Void{
 		textField = AsWingUtils.createLabel(menuItem, "label");
 		accelTextField = AsWingUtils.createLabel(menuItem, "accLabel");
 		menuItem.setFontValidated(false);
	}
	
	function installListeners():Void{
		menuItem.addEventListener(MouseEvent.ROLL_OVER, ____menuItemRollOver);
		menuItem.addEventListener(MouseEvent.ROLL_OUT, ____menuItemRollOut);
		menuItem.addActionListener(____menuItemAct);
		menuItem.addStateListener(__menuStateChanged);
	}

	function uninstallDefaults():Void {
 		LookAndFeel.uninstallBorderAndBFDecorators(menuItem);
		uninstallIcon(arrowIcon);
		uninstallIcon(checkIcon);
	}
	
	function uninstallComponents():Void{
		menuItem.removeChild(textField);
		menuItem.removeChild(accelTextField);
	}
	
	function uninstallListeners():Void{
		menuItem.removeEventListener(MouseEvent.ROLL_OVER, ____menuItemRollOver);
		menuItem.removeEventListener(MouseEvent.ROLL_OUT, ____menuItemRollOut);
		menuItem.removeActionListener(____menuItemAct);
		menuItem.removeStateListener(__menuStateChanged);
	}
	
	//---------------
	
	public function processKeyEvent(code:UInt) : Void {
		var manager:MenuSelectionManager = MenuSelectionManager.defaultManager();
		var path:Array<Dynamic> = manager.getSelectedPath();
		if(path[path.length-1] != menuItem){
			return;
		}
		if(manager.isEnterKey(code)){
			menuItem.doClick();
			return;
		}
		if(path.length > 1 && path[path.length-1] == menuItem){
			if(manager.isPageNavKey(code)){
				path.pop();
				manager.setSelectedPath(menuItem.stage, path, false);
				cast(path[path.length-1], MenuElement).processKeyEvent(code);
			}else if(manager.isItemNavKey(code)){
				path.pop();
				if(manager.isPrevItemKey(code)){
					path.push(manager.prevSubElement(cast(path[path.length-1], MenuElement), menuItem));
				}else{
					path.push(manager.nextSubElement(cast(path[path.length-1], MenuElement), menuItem));
				}
				manager.setSelectedPath(menuItem.stage, path, false);
			}
		}
	}
	
	function __menuItemRollOver(e:MouseEvent):Void{
		MenuSelectionManager.defaultManager().setSelectedPath(menuItem.stage, getPath(), false);
		menuItem.repaint();
	}
	
	function __menuItemRollOut(e:MouseEvent):Void{
		var path:Array<Dynamic> = MenuSelectionManager.defaultManager().getSelectedPath();
		if(path.length > 1 && path[path.length-1] == menuItem){
			path.pop();
			MenuSelectionManager.defaultManager().setSelectedPath(menuItem.stage, path, false);
		}
		menuItem.repaint();
	}
	
	function __menuItemAct(e:AWEvent):Void{
		MenuSelectionManager.defaultManager().clearSelectedPath(false);
		menuItem.repaint();
	}
    
    function __menuStateChanged(e:Event):Void{
    	menuItem.repaint();
    }

	function ____menuItemRollOver(e:MouseEvent):Void{
		__menuItemRollOver(e);
	}
	function ____menuItemRollOut(e:MouseEvent):Void{
		__menuItemRollOut(e);
	}
	function ____menuItemAct(e:AWEvent):Void{
		__menuItemAct(e);
	}    
	
	//---------------
	
	/**
	 * SubUI override this to do different
	 */
	function isMenu():Bool{
		return false;
	}
	
	/**
	 * SubUI override this to do different
	 */
	function isTopMenu():Bool{
		return false;
	}
	
	/**
	 * SubUI override this to do different
	 */
	function shouldPaintSelected():Bool{
		return menuItem.getModel().isRollOver();
	}
	
    public function getPath():Array<Dynamic> { //MenuElement[]
        var m:MenuSelectionManager = MenuSelectionManager.defaultManager();
        var oldPath:Array<Dynamic> = m.getSelectedPath();
        var newPath:Array<Dynamic>;
        var i:Int = oldPath.length;
        if (i == 0){
            return [];
        }
        var parent:Component = menuItem.getParent();
        if (cast(oldPath[i-1], MenuElement).getMenuComponent() == parent) {
            // The parent popup menu is the last so far
            newPath = oldPath.copy();
            newPath.push(menuItem);
        } else {
            // A sibling menuitem is the current selection
            // 
            //  This probably needs to handle 'exit submenu into 
            // a menu item.  Search backwards along the current
            // selection until you find the parent popup menu,
            // then copy up to that and add yourself...
            var j:Int;
            j = oldPath.length-1;
            while (j >= 0) {
                if (cast(oldPath[j], MenuElement).getMenuComponent() == parent){
                    break;
                }
            	j--;
            }
            newPath = oldPath.slice(0, j+1);
            newPath.push(menuItem);
        }
        return newPath;
    }	
    
	public override function paint(c:Component, g:Graphics2D, b:IntRectangle):Void{
		var mi:JMenuItem = cast(c, JMenuItem);
		paintMenuItem(mi, g, b, checkIcon, arrowIcon,
					  selectionBackground, selectionForeground,
					  defaultTextIconGap);
	}
	
	function paintMenuItem(b:JMenuItem, g:Graphics2D, r:IntRectangle, checkIcon:Icon, arrowIcon:Icon, 
		background:ASColor, foreground:ASColor, defaultTextIconGap:Int):Void{
		
		var model:ButtonModel = b.getModel();
		resetRects();
		viewRect.setRect( r );

		var font:ASFont = b.getFont();

		var acceleratorText:String = getAcceleratorText(b);
		
		// layout the text and icon
		var text:String = layoutMenuItem(
			font, b.getDisplayText(), acceleratorFont, acceleratorText, b.getIcon(),
			checkIcon, arrowIcon,
			b.getVerticalAlignment(), b.getHorizontalAlignment(),
			b.getVerticalTextPosition(), b.getHorizontalTextPosition(),
			viewRect, iconRect, textRect, acceleratorRect, 
			checkIconRect, arrowIconRect,
			b.getDisplayText() == null ? 0 : defaultTextIconGap,
			defaultTextIconGap
		);
		
		// Paint background
		paintMenuBackground(b, g, r, background);
		
		var isSelected:Bool = shouldPaintSelected();
		
		// Paint the Check
		paintCheckIcon(b, useCheckAndArrow(), 
			g, checkIconRect.x, checkIconRect.y);

		var icon:Icon = null;
		// Paint the Icon
		if(b.getIcon() != null) { 
			if(!model.isEnabled()) {
				icon = b.getDisabledIcon();
			} else if(model.isPressed() && model.isArmed()) {
				icon = b.getPressedIcon();
				if(icon == null) {
					// Use default icon
					icon = b.getIcon();
				} 
			} else {
				icon = b.getIcon();
			}
		}
		paintIcon(b, icon, g, iconRect.x, iconRect.y);
		var tc:ASColor;
		// Draw the Text
		if(text != null && text != "") {
			tc = b.getForeground();
			if(isSelected){
				tc = selectionForeground;
			}
			if(!b.isEnabled()){
				if(disabledForeground != null){
					tc = disabledForeground;
				}else{
					tc = BasicGraphicsUtils.getDisabledColor(b);
				}
			}
			textField.visible = true;
			paintTextField(b, textRect, textField, text, font, tc, !b.isFontValidated());
			b.setFontValidated(true);
		}else{
			textField.visible = false;
		}
	
		// Draw the Accelerator Text
		if(acceleratorText != null && acceleratorText !="") {
			//Get the maxAccWidth from the parent to calculate the offset.
			var accOffset:Int = 0;
			var parent:Container = menuItem.getParent();
			if (parent != null) {
				var p:Container = parent;
				var maxValueInt:Int;
				if(p.getClientProperty(BasicMenuItemUI.MAX_ACC_WIDTH) == null){
					maxValueInt = acceleratorRect.width;
				}else{
					maxValueInt = p.getClientProperty(BasicMenuItemUI.MAX_ACC_WIDTH);
				}
				
				//Calculate the offset, with which the accelerator texts will be drawn with.
				accOffset = maxValueInt - acceleratorRect.width;
			}
	  		var accTextFieldRect:IntRectangle = new IntRectangle();
			accTextFieldRect.x = acceleratorRect.x - accOffset;
			accTextFieldRect.y = acceleratorRect.y;
			tc = acceleratorForeground;
			if(!model.isEnabled()) {
				if(disabledForeground != null){
					tc = disabledForeground;
				}else{
					tc = BasicGraphicsUtils.getDisabledColor(b);
				}
			} else if (isSelected) {
				tc = acceleratorSelectionForeground;
			}
			accelTextField.visible = true;
			paintTextField(b, accTextFieldRect, accelTextField, acceleratorText, acceleratorFont, tc, !acceleratorFontValidated);
			acceleratorFontValidated = true;
		}else{
			accelTextField.visible = false;
		}

		// Paint the Arrow
		paintArrowIcon(b, useCheckAndArrow(), 
			g, arrowIconRect.x, arrowIconRect.y);
	 }
	
	function paintCheckIcon(b:JMenuItem, isPaint:Bool, g:Graphics2D, x:Int, y:Int):Void{
		if(checkIcon == null) return;
		
		if(!isPaint){
			setIconVisible(checkIcon, false);
		}else{
			setIconVisible(checkIcon, true);
			checkIcon.updateIcon(b, g, x, y);
		}
	}
	
	function paintArrowIcon(b:JMenuItem, isPaint:Bool, g:Graphics2D, x:Int, y:Int):Void{
		if(arrowIcon == null) return;
		
		if(!isPaint){
			setIconVisible(arrowIcon, false);
		}else{
			setIconVisible(arrowIcon, true);
			arrowIcon.updateIcon(b, g, x, y);
		}	
	}
	
	function paintIcon(b:JMenuItem, icon:Icon, g:Graphics2D, x:Int, y:Int):Void{
        var icons:Array<Dynamic> = getIcons();
        for(i in 0...icons.length){
        	var ico:Icon = icons[i];
			setIconVisible(ico, false);
        }
        if(icon != null){
        	setIconVisible(icon, true);
        	icon.updateIcon(b, g, x, y);
        }	
	}
	
    function setIconVisible(icon:Icon, visible:Bool):Void{
    	if(icon.getDisplay(menuItem) != null){
    		icon.getDisplay(menuItem).visible = visible;
    	}
    }
    
    function getIcons():Array<Dynamic>{
    	var arr:Array<Dynamic> = new Array();
    	var button:AbstractButton = menuItem;
    	if(button.getIcon() != null){
    		arr.push(button.getIcon());
    	}
    	if(button.getDisabledIcon() != null){
    		arr.push(button.getDisabledIcon());
    	}
    	if(button.getSelectedIcon() != null){
    		arr.push(button.getSelectedIcon());
    	}
    	if(button.getDisabledSelectedIcon() != null){
    		arr.push(button.getDisabledSelectedIcon());
    	}
    	if(button.getRollOverIcon() != null){
    		arr.push(button.getRollOverIcon());
    	}
    	if(button.getRollOverSelectedIcon() != null){
    		arr.push(button.getRollOverSelectedIcon());
    	}
    	if(button.getPressedIcon() != null){
    		arr.push(button.getPressedIcon());
    	}
    	return arr;
    }	
	
	function paintMenuBackground(menuItem:JMenuItem, g:Graphics2D, r:IntRectangle, bgColor:ASColor):Void {
		var color:ASColor = bgColor;
		if(menuItem.isOpaque()) {
			if (!shouldPaintSelected()) {
				color = menuItem.getBackground();
			}
			g.fillRectangle(new SolidBrush(color), r.x, r.y, r.width, r.height);
		}else if(shouldPaintSelected() && (menuItem.getBackgroundDecorator() == null || menuItem.getBackgroundDecorator() == DefaultEmptyDecoraterResource.INSTANCE)){
			g.fillRectangle(new SolidBrush(color), r.x, r.y, r.width, r.height);
		}
	}	
	

	function paintTextField(b:JMenuItem, tRect:IntRectangle, textField:TextField, text:String, font:ASFont, color:ASColor, validateFont:Bool):Void{
		if(textField.text != text){
			textField.text = text;
		}
		if(validateFont){
			AsWingUtils.applyTextFont(textField, font);
		}
		AsWingUtils.applyTextColor(textField, color);
		textField.x = tRect.x;
		textField.y = tRect.y;
		if(b.getMnemonicIndex() >= 0){
			textField.setTextFormat(
				new TextFormat(null, null, null, null, null, true), 
				b.getMnemonicIndex());
		}
	}	
	

	// these rects are used for painting and preferredsize calculations.
	// they used to be regenerated constantly.  Now they are reused.
	static var zeroRect:IntRectangle = new IntRectangle();
	static var iconRect:IntRectangle = new IntRectangle();
	static var textRect:IntRectangle = new IntRectangle();
	static var acceleratorRect:IntRectangle = new IntRectangle();
	static var checkIconRect:IntRectangle = new IntRectangle();
	static var arrowIconRect:IntRectangle = new IntRectangle();
	static var viewRect:IntRectangle = new IntRectangle();
	static var r:IntRectangle = new IntRectangle();

	function resetRects():Void {
		iconRect.setRect(zeroRect);
		textRect.setRect(zeroRect);
		acceleratorRect.setRect(zeroRect);
		checkIconRect.setRect(zeroRect);
		arrowIconRect.setRect(zeroRect);
		viewRect.setRectXYWH(0, 0, 100000, 100000);
		r.setRect(zeroRect);
	}	

	/**
	 * Returns the a menu item's preferred size with specified icon and text.
	 */
	function getPreferredMenuItemSize(b:JMenuItem, 
													 checkIcon:Icon,
													 arrowIcon:Icon,
													 defaultTextIconGap:Int):IntDimension{
		var icon:Icon = b.getIcon(); 
		var text:String = b.getDisplayText();
		var acceleratorText:String = getAcceleratorText(b);

		var font:ASFont = b.getFont();

		resetRects();
		
		layoutMenuItem(
				  font, text, acceleratorFont, acceleratorText, icon, checkIcon, arrowIcon,
				  b.getVerticalAlignment(), b.getHorizontalAlignment(),
				  b.getVerticalTextPosition(), b.getHorizontalTextPosition(),
				  viewRect, iconRect, textRect, acceleratorRect, checkIconRect, arrowIconRect,
				  text == null ? 0 : defaultTextIconGap,
				  defaultTextIconGap
				  );
		// find the union of the icon and text rects
		r = textRect.union(iconRect);
		
		// To make the accelerator texts appear in a column, find the widest MenuItem text
		// and the widest accelerator text.

		//Get the parent, which stores the information.
		var parent:Container = menuItem.getParent();
	
		//Check the parent, and see that it is not a top-level menu.
		if (parent != null &&  !isTopMenu()) {
			var p:Container = parent;
			//Get widest text so far from parent, if no one exists null is returned.
			var maxTextValue:Int = p.getClientProperty(BasicMenuItemUI.MAX_TEXT_WIDTH);
			var maxAccValue:Int = p.getClientProperty(BasicMenuItemUI.MAX_ACC_WIDTH);
						
			//Compare the text widths, and adjust the r.width to the widest.
			if (r.width < maxTextValue) {
				r.width = maxTextValue;
			} else {
				p.putClientProperty(BasicMenuItemUI.MAX_TEXT_WIDTH, r.width);
			}
			
		  //Compare the accelarator widths.
			if (acceleratorRect.width > maxAccValue) {
				maxAccValue = acceleratorRect.width;
				p.putClientProperty(BasicMenuItemUI.MAX_ACC_WIDTH, acceleratorRect.width);
			}
			
			//Add on the widest accelerator 
			r.width += maxAccValue;
			r.width += defaultTextIconGap;
		}
	
		if(useCheckAndArrow()) {
			// Add in the checkIcon
			r.width += checkIconRect.width;
			r.width += defaultTextIconGap;
			
			// Add in the arrowIcon
			r.width += defaultTextIconGap;
			r.width += arrowIconRect.width;
		}	

		r.width += 2*defaultTextIconGap;

		var insets:Insets = b.getInsets();
		if(insets != null) {
			r.width += insets.left + insets.right;
			r.height += insets.top + insets.bottom;
		}
		r.width = Math.ceil(r.width);
		r.height = Math.ceil(r.height);
		// if the width is even, bump it up one. This is critical
		// for the focus dash line to draw properly
		if(r.width%2 == 0) {
			r.width++;
		}

		// if the height is even, bump it up one. This is critical
		// for the text to center properly
		if(r.height%2 == 0) {
			r.height++;
		}
		return r.getSize();
	}
	
	function getAcceleratorText(b:JMenuItem):String{
		if(b.getAccelerator() == null){
			return "";
		}else{
			return b.getAccelerator().getDescription();
		}
	}
	
	/** 
	 * Compute and return the location of the icons origin, the 
	 * location of origin of the text baseline, and a possibly clipped
	 * version of the compound labels string.  Locations are computed
	 * relative to the viewRect rectangle. 
	 */
	function layoutMenuItem(
		font:ASFont, 
		text:String, 
		accelFont:ASFont, 
		acceleratorText:String, 
		icon:Icon, 
		checkIcon:Icon, 
		arrowIcon:Icon, 
		verticalAlignment:Int, 
		horizontalAlignment:Int, 
		verticalTextPosition:Int, 
		horizontalTextPosition:Int, 
		viewRect:IntRectangle, 
		iconRect:IntRectangle, 
		textRect:IntRectangle, 
		acceleratorRect:IntRectangle, 
		checkIconRect:IntRectangle, 
		arrowIconRect:IntRectangle, 
		textIconGap:Int, 
		menuItemGap:Int
		):String
	{

		AsWingUtils.layoutCompoundLabel(menuItem, font, text, icon, verticalAlignment, 
							horizontalAlignment, verticalTextPosition, 
							horizontalTextPosition, viewRect, iconRect, textRect, 
							textIconGap);
										
		/* Initialize the acceelratorText bounds rectangle textRect.  If a null 
		 * or and empty String was specified we substitute "" here 
		 * and use 0,0,0,0 for acceleratorTextRect.
		 */
		if(acceleratorText == null || acceleratorText == "") {
			acceleratorRect.width = acceleratorRect.height = 0;
			acceleratorText = "";
		}else {
			var td:IntDimension = accelFont.computeTextSize(acceleratorText);
			acceleratorRect.width = td.width;
			acceleratorRect.height = td.height;
		}

		/* Initialize the checkIcon bounds rectangle's width & height.
		 */
		if( useCheckAndArrow()) {
			if (checkIcon != null) {
				checkIconRect.width = checkIcon.getIconWidth(menuItem);
				checkIconRect.height = checkIcon.getIconHeight(menuItem);
			} else {
				checkIconRect.width = checkIconRect.height = 0;
			}
			/* Initialize the arrowIcon bounds rectangle width & height.
			 */
			if (arrowIcon != null) {
				arrowIconRect.width = arrowIcon.getIconWidth(menuItem);
				arrowIconRect.height = arrowIcon.getIconHeight(menuItem);
			} else {
				arrowIconRect.width = arrowIconRect.height = 0;
			}
		}

		var labelRect:IntRectangle = iconRect.union(textRect);
		textRect.x += menuItemGap;
		iconRect.x += menuItemGap;

		// Position the Accelerator text rect
		acceleratorRect.x = viewRect.x + viewRect.width - arrowIconRect.width - menuItemGap*2 - acceleratorRect.width;
		
		// Position the Check and Arrow Icons 
		if (useCheckAndArrow()) {
			checkIconRect.x = viewRect.x + menuItemGap;
			textRect.x += menuItemGap + checkIconRect.width;
			iconRect.x += menuItemGap + checkIconRect.width;
			arrowIconRect.x = viewRect.x + viewRect.width - menuItemGap - arrowIconRect.width;
		}

		// Align the accelertor text and the check and arrow icons vertically
		// with the center of the label rect.  
		acceleratorRect.y = labelRect.y + Math.floor(labelRect.height/2) - Math.floor(acceleratorRect.height/2);
		if( useCheckAndArrow() ) {
			arrowIconRect.y = labelRect.y + Math.floor(labelRect.height/2) - Math.floor(arrowIconRect.height/2);
			checkIconRect.y = labelRect.y + Math.floor(labelRect.height/2) - Math.floor(checkIconRect.height/2);
		}

		return text;
	}	
	
	function useCheckAndArrow():Bool{
		return !isTopMenu();
	}
	
	public override function getPreferredSize(c:Component):IntDimension{
		var b:JMenuItem = cast(c, JMenuItem);
		return getPreferredMenuItemSize(b, checkIcon, arrowIcon, defaultTextIconGap);
	}

	public override function getMinimumSize(c:Component):IntDimension{
		var size:IntDimension = menuItem.getInsets().getOutsideSize();
		if(menuItem.getMargin() != null){
			size = menuItem.getMargin().getOutsideSize(size);
		}
		return size;
	}

	public override function getMaximumSize(c:Component):IntDimension{
		return IntDimension.createBigDimension();
	}	
}
