/*
 Copyright aswing.org, see the LICENCE.txt.
*/

package org.aswing.plaf.basic;

import Import_org_aswing;
import Import_org_aswing_graphics;
import Import_org_aswing_geom;
import Import_org_aswing_plaf;
import org.aswing.plaf.basic.icon.ArrowIcon;
import org.aswing.util.Timer;
import org.aswing.border.LineBorder;
import flash.events.MouseEvent;
import flash.events.Event;
import flash.geom.Rectangle;
import org.aswing.event.ListItemEvent;
import org.aswing.event.FocusKeyEvent;
import flash.ui.Keyboard;
import org.aswing.event.AWEvent;

/**
 * Basic combo box ui imp.
 * @author iiley
 * @private
 */
class BasicComboBoxUI extends BaseComponentUI, implements org.aswing.plaf.ComboBoxUI {
		
	
		
	var dropDownButton:Component;
	var box:JComboBox;
	var popup:JPopup;
	var scollPane:JScrollPane;
    var arrowShadowColor:ASColor;
    var arrowLightColor:ASColor;
	
	var popupTimer:Timer;
	var moveDir:Float;
		
	public function new() {
		super();
	}
	
    public override function installUI(c:Component):Void{
    	box = JComboBox(c);
		installDefaults();
		installComponents();
		installListeners();
    }
    
	public override function uninstallUI(c:Component):Void{
    	box = JComboBox(c);
		uninstallDefaults();
		uninstallComponents();
		uninstallListeners();
    }
    
	function getPropertyPrefix():String {
		return "ComboBox.";
	}
	
	function installDefaults():Void{
		var pp:String = getPropertyPrefix();
        LookAndFeel.installBorderAndBFDecorators(box, pp);
        LookAndFeel.installColorsAndFont(box, pp);
        LookAndFeel.installBasicProperties(box, pp);
		arrowShadowColor = getColor(pp+"arrowShadowColor");
		arrowLightColor = getColor(pp+"arrowLightColor");
	}
    
    function uninstallDefaults():Void{
    	LookAndFeel.uninstallBorderAndBFDecorators(box);
    }
    
	function installComponents():Void{
		dropDownButton = createDropDownButton();
		dropDownButton.setUIElement(true);
		box.addChild(dropDownButton);
    }
	function uninstallComponents():Void{
		box.removeChild(dropDownButton);
		if(isPopupVisible(box)){
			setPopupVisible(box, false);
		}
    }
	
	function installListeners():Void{
		getPopupList().setFocusable(false);
		box.addEventListener(MouseEvent.MOUSE_DOWN, __onBoxPressed);
		box.addEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onFocusKeyDown);
		box.addEventListener(AWEvent.FOCUS_LOST, __onFocusLost);
		box.addEventListener(Event.REMOVED_FROM_STAGE, __onBoxRemovedFromStage);
		getPopupList().addEventListener(ListItemEvent.ITEM_CLICK, __onListItemReleased);
		popupTimer = new Timer(40);
		popupTimer.addActionListener(__movePopup);
	}
    
    function uninstallListeners():Void{
    	popupTimer.stop();
    	popupTimer = null;
		box.removeEventListener(MouseEvent.MOUSE_DOWN, __onBoxPressed);
		box.removeEventListener(FocusKeyEvent.FOCUS_KEY_DOWN, __onFocusKeyDown);
		box.removeEventListener(AWEvent.FOCUS_LOST, __onFocusLost);
		box.removeEventListener(Event.REMOVED_FROM_STAGE, __onBoxRemovedFromStage);
		getPopupList().removeEventListener(ListItemEvent.ITEM_CLICK, __onListItemReleased);
    }
    
	public override function paint(c:Component, g:Graphics2D, b:IntRectangle):Void{
		super.paint(c, g, b);
		layoutCombobox();
		dropDownButton.setEnabled(box.isEnabled());
	}
        
    override function paintBackGround(c:Component, g:Graphics2D, b:IntRectangle):Void{
    	if(c.isOpaque()){
	 		var bgColor:ASColor;
	 		bgColor = (c.getBackground() == null ? ASColor.WHITE : c.getBackground());
	 		if(!box.isEnabled()){
	 			bgColor = BasicGraphicsUtils.getDisabledColor(c);
	 		}
			g.fillRectangle(new SolidBrush(bgColor), b.x, b.y, b.width, b.height);
    	}
    }
    
    /**
     * Just override this method if you want other LAF drop down buttons.
     */
    function createDropDownButton():Component{
    	var btn:JButton = new JButton("", new ArrowIcon(
    				Math.PI/2, 8,
				    arrowLightColor,
				    arrowShadowColor
    	));
    	btn.setFocusable(false);
    	btn.setPreferredSize(new IntDimension(16, 16));
    	return btn;
    }
    
    function getScollPane():JScrollPane{
    	if(scollPane == null){
    		scollPane = new JScrollPane(getPopupList());
    		scollPane.setBorder(getBorder(getPropertyPrefix()+"popupBorder"));
    		scollPane.setOpaque(true);
    	}
    	return scollPane;
    }
    
    function getPopup():JPopup{
    	if(popup == null){
    		popup = new JPopup(box.root, false);
    		popup.setLayout(new BorderLayout());
    		popup.append(getScollPane(), BorderLayout.CENTER);
    		popup.setClipMasked(false);
    	}
    	return popup;
    }
    
    function getPopupList():JList{
    	return box.getPopupList();
    }
    
    function viewPopup():Void{
    	if(!box.isOnStage()){
    		return;
    	}
		var width:Int = box.getWidth();
		var cellHeight:Int;
		if(box.getListCellFactory().isAllCellHasSameHeight()){
			cellHeight = box.getListCellFactory().getCellHeight();
		}else{
			cellHeight = box.getPreferredSize().height;
		}
		var height:Int = Math.min(box.getItemCount(), box.getMaximumRowCount())*cellHeight;
		var i:Insets = getScollPane().getInsets();
		height += i.top + i.bottom;
		i = getPopupList().getInsets();
		height += i.top + i.bottom;
		getPopup().changeOwner(AsWingUtils.getOwnerAncestor(box));
		getPopup().setSizeWH(width, height);
		getPopup().show();
		startMoveToView();
		AsWingManager.callLater(__addMouseDownListenerToStage);
    }
    
    function __addMouseDownListenerToStage():Void{
    	if(getPopup().isVisible() && box.stage){
			box.stage.addEventListener(MouseEvent.MOUSE_DOWN, __onMouseDownWhenPopuped, false, 0, true);
    	}
    }
    
    function hidePopup():Void{
    	if(box.stage){
    		box.stage.removeEventListener(MouseEvent.MOUSE_DOWN, __onMouseDownWhenPopuped);
    	}
		popupTimer.stop();
    	if(getPopup().isVisible()){
			getPopup().dispose();
    	}
    }
    
    var scrollRect:Rectangle;
    //return the destination pos
    function startMoveToView():Void{
    	var popupPane:JPopup = getPopup();
    	var height:Int = popupPane.getHeight();
    	var popupPaneHeight:Int = height;
    	var downDest:IntPoint = box.componentToGlobal(new IntPoint(0, box.getHeight()));
    	var upDest:IntPoint = new IntPoint(downDest.x, downDest.y - box.getHeight() - popupPaneHeight);
    	var visibleBounds:IntRectangle = AsWingUtils.getVisibleMaximizedBounds(popupPane.parent);
    	var distToBottom:Int = visibleBounds.y + visibleBounds.height - downDest.y - popupPaneHeight;
    	var distToTop:Int = upDest.y - visibleBounds.y;
    	var gp:IntPoint = box.getGlobalLocation();
    	if(distToBottom > 0 || (distToBottom < 0 && distToTop < 0 && distToBottom > distToTop)){
    		moveDir = 1;
    		gp.y += box.getHeight();
			scrollRect = new Rectangle(0, height, popupPane.getWidth(), 0);
    	}else{
    		moveDir = -1;
			scrollRect = new Rectangle(0, 0, popupPane.getWidth(), 0);
    	}
    	popupPane.setGlobalLocation(gp);
    	popupPane.scrollRect = scrollRect;
    	
		popupTimer.restart();
    }
    
    function setComboBoxValueFromListSelection():Void{
		var selectedValue:Dynamic = getPopupList().getSelectedValue();
		box.setSelectedItem(selectedValue);
    }
    
    //-----------------------------
    
    function __movePopup(e:Event):Void{
    	var popupPane:JPopup = getPopup();
    	var popupPaneHeight:Int = popupPane.getHeight();
    	var maxTime:Int = 10;
    	var minTime:Int = 3;
    	var speed:Int = 50;
    	if(popupPaneHeight < speed*minTime){
    		speed = Math.ceil(popupPaneHeight/minTime);
    	}else if(popupPaneHeight > speed*maxTime){
    		speed = Math.ceil(popupPaneHeight/maxTime);
    	}
    	if(popupPane.height - scrollRect.height <= speed){
    		//motion ending
    		speed = popupPane.height - scrollRect.height;
			popupTimer.stop();
    	}
		if(moveDir > 0){
			scrollRect.y -= speed;
			scrollRect.height += speed;
		}else{
			popupPane.y -= speed;
			scrollRect.height += speed;
		}
    	popupPane.scrollRect = scrollRect;
    }
    
    function __onFocusKeyDown(e:FocusKeyEvent):Void{
    	var code:UInt = e.keyCode;
    	if(code == Keyboard.DOWN){
    		if(!isPopupVisible(box)){
    			setPopupVisible(box, true);
    			return;
    		}
    	}
    	if(code == Keyboard.ESCAPE){
    		if(isPopupVisible(box)){
    			setPopupVisible(box, false);
    			return;
    		}
    	}
    	if(code == Keyboard.ENTER && isPopupVisible(box)){
	    	hidePopup();
	    	setComboBoxValueFromListSelection();
	    	return;
    	}
    	var list:JList = getPopupList();
    	var index:Int = list.getSelectedIndex();
    	if(code == Keyboard.DOWN){
    		index += 1;
    	}else if(code == Keyboard.UP){
    		index -= 1;
    	}else if(code == Keyboard.PAGE_DOWN){
    		index += box.getMaximumRowCount();
    	}else if(code == Keyboard.PAGE_UP){
    		index -= box.getMaximumRowCount();
    	}else if(code == Keyboard.HOME){
    		index = 0;
    	}else if(code == Keyboard.END){
    		index = list.getModel().getSize()-1;
    	}else{
    		return;
    	}
    	index = Math.max(0, Math.min(list.getModel().getSize()-1, index));
    	list.setSelectedIndex(index, false);
    	list.ensureIndexIsVisible(index);
    }
    
    function __onFocusLost(e:Event):Void{
    	hidePopup();
    }
    
    function __onBoxRemovedFromStage(e:Event):Void{
    	hidePopup();
    }
    
    function __onListItemReleased(e:Event):Void{
    	hidePopup();
    	setComboBoxValueFromListSelection();
    }
    
    function __onBoxPressed(e:Event):Void{
    	if(!isPopupVisible(box)){
    		if(box.isEditable()){
    			if(!box.getEditor().getEditorComponent().hitTestMouse()){
    				setPopupVisible(box, true);
    			}
    		}else{
    			setPopupVisible(box, true);
    		}
    	}else{
    		hidePopup();
    	}
    }
    
    function __onMouseDownWhenPopuped(e:Event):Void{
    	if(!getPopup().hitTestMouse() && !box.hitTestMouse()){
    		hidePopup();
    	}
    }
    
	/**
     * Set the visiblity of the popup
     */
	public function setPopupVisible(c:JComboBox, v:Bool):Void{
		if(v){
			viewPopup();
		}else{
			hidePopup();
		}
	}
	
	/** 
     * Determine the visibility of the popup
     */
	public function isPopupVisible(c:JComboBox):Bool{
		return getPopup().isVisible();
	}
	
	//---------------------Layout Implementation---------------------------
    function layoutCombobox():Void{
    	var td:IntDimension = box.getSize();
		var insets:Insets = box.getInsets();
		var top:Int = insets.top;
		var left:Int = insets.left;
		var right:Int = td.width - insets.right;
		
		var height:Int = td.height - insets.top - insets.bottom;
    	var buttonSize:IntDimension = dropDownButton.getPreferredSize(); 
    	dropDownButton.setSizeWH(buttonSize.width, height);
    	dropDownButton.setLocationXY(right - buttonSize.width, top);
    	box.getEditor().getEditorComponent().setLocationXY(left, top);
    	box.getEditor().getEditorComponent().setSizeWH(td.width-insets.left-insets.right- buttonSize.width, height);
    }
    
    public override function getPreferredSize(c:Component):IntDimension{
    	var insets:Insets = box.getInsets();
    	var listPreferSize:IntDimension = getPopupList().getPreferredSize();
    	var ew:Int = listPreferSize.width;
    	var wh:Int = box.getEditor().getEditorComponent().getPreferredSize().height;
    	var buttonSize:IntDimension = dropDownButton.getPreferredSize(); 
    	buttonSize.width += ew;
    	if(wh > buttonSize.height){
    		buttonSize.height = wh;
    	}
    	return insets.getOutsideSize(buttonSize);
    }

    public override function getMinimumSize(c:Component):IntDimension{
    	return box.getInsets().getOutsideSize(dropDownButton.getPreferredSize());
    }

    public override function getMaximumSize(c:Component):IntDimension{
		return IntDimension.createBigDimension();
    }    
}
